#!/usr/bin/env python3

import sys
import yandexcloud
import argparse
import json
from google.protobuf.json_format import MessageToDict
from yandex.cloud.compute.v1.instance_service_pb2_grpc import InstanceServiceStub
from yandex.cloud.compute.v1.instance_service_pb2 import ListInstancesRequest


def main():

    ####### Поменяй на свое #######
    inventory_groups = ["app", "db"]
    sa_json_path = '../../temp/terraform_temp/key.json'
    folder_id = 'b1gprlskmuless8prlue'
    ##################################

    parser = argparse.ArgumentParser(
        description="""Generate json file and print them content to stdout.""",
        formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('--list', action='store_true', help='print json content to stdout')
    parser.add_argument('--host', help='print single host variables')
    parser.add_argument('--save', action='store_true', help='save inventory.json file in current path')

    args = parser.parse_args()


    input_key_file = open(sa_json_path)
    sdk = yandexcloud.SDK(service_account_key=json.load(input_key_file)).client(InstanceServiceStub)
    input_key_file.close()
    hosts = MessageToDict(sdk.List(ListInstancesRequest(folder_id=folder_id)))

    ungrouped_childs = []
    all_hosts = dict()
    for host in hosts['instances']:
        for interface in host['networkInterfaces']:
            interface = interface['primaryV4Address']['oneToOneNat']['address']
            if interface is not None:
                all_hosts[host['name']] = interface
                ungrouped_childs.append(host['name'])

    hostvars = dict()
    children = ['ungrouped']
    inventory_skelet = { "_meta": { "hostvars" : hostvars }, "all": { "children" : children }, "ungrouped": { "children" : ungrouped_childs } }
    for host_name, host_ip in all_hosts.items():
        host = {host_name: {"ansible_host": host_ip}}
        hostvars.update(host)
        for inventory_group in inventory_groups:
            if not inventory_group in children:
                children.insert(0,inventory_group)
                inventory_skelet[inventory_group] = {"hosts" : []}
            if inventory_group in host_name:
                inventory_skelet[inventory_group]['hosts'].append(host_name)
                inventory_skelet['ungrouped']['children'].remove(host_name)
    inventory_json = json.dumps(inventory_skelet, indent=4, sort_keys=True)

    if args.list:
        print(inventory_json)
        sys.exit(0)

    if args.host:
        print(inventory_skelet["_meta"]["hostvars"][args.host])
        sys.exit(0)

    if args.save:
        f = open(f'inventory.json', 'w')
        f.write(inventory_json)
        f.close()
        sys.exit(0)

if __name__ == '__main__':
    main()
