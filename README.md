# buffstyles_infra


## Домашнее задание №5.
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


## Домашнее задание №6.

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

## Домашнее задание №7.

### В процессе работы сделано:

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
