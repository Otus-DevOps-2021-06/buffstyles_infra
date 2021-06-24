# buffstyles_infra


## Домашнее задание №5 - cloud-bastion.
### Подключение по ssh.

Простой способ для подключения к `someinternalhost` в одну команду с использованием `ProxyJump`:
```
ssh -i ~/.ssh/appuser -J 'bastion_user'@'bastion_public_ip' 'someinternalhost_user'@'someinternalhost_private_ip'
```

Отредактируем файл `~/.ssh/config` для более лаконичной команды:
```
Host bastion
	Hostname BASTION_PUBLIC_IP
	User appuser
	IdentityFile ~/.ssh/appuser
Host someinternalhost
	Hostname SOMEINTERNALHOST_PRIVATE_IP
	User appuser
	IdentityFile ~/.ssh/appuser
```

Теперь можем подключиться к `someinternalhost` используя команду:
```
ssh -J bastion someinternalhost
```
### Дополнительное задание

Для того, чтобы подключиться к `someinternalhost` из локальной консоли используя команду:
```
ssh someinternalhost
```

Приводим файл `~/.ssh/config` к следующему виду:
```
Host bastion
	Hostname BASTION_PUBLIC_IP
	User appuser
	IdentityFile ~/.ssh/appuser
Host someinternalhost
	Hostname SOMEINTERNALHOST_PRIVATE_IP
	User appuser
	IdentityFile ~/.ssh/appuser
	ProxyCommand ssh bastion -W %h:%p
```

### Данные для проверки VPN

bastion_IP = 84.201.173.236

someinternalhost_IP = 10.128.0.24


## Домашнее задание №6 - cloud-testapp.

### Данные для проверки приложения

testapp_IP = 84.252.130.146

testapp_port = 9292

### Дополнительное задание

В качестве `startup script` используется файл `cloudinit.yaml`.

Команда в Яндекс CLI для запуска инстанса с уже запущенным приложением:
```
yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --zone ru-central1-a \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --metadata-from-file user-data=./cloudinit.yaml
```

## Домашнее задание №7 - packer-base.

### Основное задание:

  - Установлен Packer.
  - Создан сервисный аккаунт для Packer в Yandex.Cloud, делегированы необходимые права.
  - Создан шаблон `ubuntu16.json`, содержащий описание образа ВМ с предустановленными Ruby и MongoDB.
  - С помощью Packer создан образ `reddit-base` из шаблона.
  - Для проверки создана ВМ на основе образа, установлено приложение `reddit`, проведена проверка работоспособности приложения.
  - Шаблон `ubuntu16.json` параметризирован в соответствии с требованиями. Пример переменных хранится в файле `variables.json.example`, боевой файл добавлен в `.gitignore`.

### Дополнительное задание 1:

 - Создан шаблон `immutable.json` для создания bake-образа. 1
 - Из шаблона создан образ `reddit-full` поверх ранее созданного образа `reddit-base`. Новый образ содержит все зависимости и код приложения `reddit`.
 - Для запуска приложения при старте инстанса используется systemd unit `reddit.service`.

 ### Дополнительное задание 2:

 - Создан скрипт `create-reddit-vm.sh`, автоматически создающий ВМ из нашего bake-образа.


## Домашнее задание №8 - terraform-1.

### Основное задание:

 - Установлен и инициализирован Terraform.
 - Создан файл `main.tf`.
 - В файле `main.tf` определен провайдер `yandex` и ресурс `yandex_compute_instance` для создания виртуальной машины в облаке Яндекса.
 - Создана виртуальная машина с помощью Terraform.
 - Создан файл `outputs.tf`. В вывод добавлен внешний IP адрес виртуальной машины.
 - В файл `main.tf` добавлены провиженеры для деплоя нашего приложения на созданной виртуальной машине (для работы провиженера уже созданную машину необходимо пересоздать, например, с указанием `terraform taint`).
 - Определены input переменные для приватного ключа в определении подключения для провижинеров и для зоны в ресурсе `yandex_compute_instance.app`.
 - Для образца создан файл `terraform.tfvars.example`.

 ### Дополнительное задание 1:

  - Создан файл `lb.tf` с описанием HTTP балансировщика, направляющего трафик на наше
  развернутое приложение на инстансе `reddit-app`.
  - В output переменные добавлен адрес балансировщика.

### Дополнительное задание 2:

  - В файл `main.tf` добавлен код описания еще одного инстанса приложения - `reddit-app-2`.
  - В балансировщик добавлен дополнительный инстанс.
  - В output переменные добавлен адрес второго инстанса.

Данный подход генерирует большое количество повторяющегося кода. Также плохо масштабировать наше приложение (много ручных действия, велика вероятность ошибки).

### Дополнительное задание 3:

  - Описание инстанса переписано с использованием `count`.
  - Количество инстансов вынесено в input переменные.
  - Соответствующие изменения внесены в балансировщик и output переменные.

## Домашнее задание №9 - terraform-2.

### Основное задание:

 - Создано два новых шаблона packer `db.json` и `app.json` для для сборки образов ВМ с mongodb и с ruby соответственно.
 - Созданы модули terraform для запуска ВМ с ruby и с mongodb.
 - В файле `main.tf` вставлены секции вызова созданных модулей.
 - Создано два идентичных окружения `stage` и `prod`.
 - Конфигурация модулей параметризирована.
 - Конфигурационные файлы отформатированы.

 ### Дополнительное задание 1:

 - Настроено хранение стейт файла в удаленном бекенде для окружений `stage` и `prod`, используя Yandex Object Storage в качестве бекенда. Описание бекенда вынесено в отдельный файл `backend.tf` в каждом окружении.
 - Проверена работоспособность удаленного бекенда. Terraform видит текущее состояние инфраструктуры независимо от директории, в которой он запускается.
 - Для работы блокировок создана `serverless Yandex  Database` через веб-консоль Yandex Cloud. В веб-консоли узнаем `endpoint`созданной базы. Далее через `aws cli` создана таблица `tfstate-lock-table` (имя может быть любым), например:

```
endpoint="https://docapi.serverless.yandexcloud.net/ru-central1/b1guu7b8p27pq5v031iu/etn01q6lcqgdm09hrass"

table_name="tfstate-lock-table"

aws dynamodb create-table \
   --table-name $table_name \
   --attribute-definitions \
     AttributeName=LockID,AttributeType=S \
   --key-schema \
     AttributeName=LockID,KeyType=HASH \
   --endpoint $endpoint
```

 Также указываем endpoint URL базы и имя таблицы в файле `backend.tf`, например:

```
dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1guu7b8p27pq5v031iu/etn01q6lcqgdm09hrass"
dynamodb_table    = "tfstate-lock-table"
```

### Дополнительное задание 2:

 - Для работы `provisioner` для деплоя нашего приложения создан отдельный модуль `deploy`. Файлы, используемые в `provisioner`, находятся в директории модуля.
 - Добавлена переменная `enable`. При запуске terraform запросит значение переменной. Если указать `yes`, то приложение будет установлено, в противном случае инфраструктура поднимется без приложения.

## Домашнее задание №10 - ansible-1.

### Основное задание:

 - Создан файл инвентаря.
 - Создан файл инвентаря в yaml разметке.
 - Создан файл конфигурации, соответственно переписаны файлы инвентарей.
 - Создан плейбук. Установлен пакет git и склонирован репозиторий.
 - Выполнена команда `ansible app -m command -a 'rm -rf ~/reddit'` и затем снова выполнен плейбук.
 Ansible снова склонировал репозиторий, так как не нашел предыдущего и посчитал состояние измененным.

### Дополнительное задание 1:
 - Создан скрипт `nechitaemoe_nechto.py`, который генерирует динамический `inventory.json` "на лету" из инфраструктуры Yandex Cloud.
 Некоторые переменные необходимо указать в начале кода скрипта.
 - Ключ `--list` выводит содержимое в stdout.
 - Ключ `--host HOSTNAME` выводит IP адрес определенного хоста инвентаря, например:
```
 python nechitaemoe_nechto.py --host reddit-app
{'ansible_host': '217.328.231.176'}
```
 - Ключ `--save` создаст файл `inventory.json` в текущей директории.
 - Скрипт можно использовать в качестве inventory в `ansible.cfg`.
