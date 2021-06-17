## buffstyles_infra
buffstyles Infra repository

# Подключения по ssh

Простой способ для подключения к `someinternalhost` в одну команду с использованием `ProxyJump`:
`ssh -i ~/.ssh/appuser -J 'bastion_user'@'bastion_public_ip' 'someinternalhost_user'@'someinternalhost_private_ip'`


Редактируем `~/.ssh/config` файл для более лаконичной команды:
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

Для того, чтобы подключиться к `someinternalhost` из локальной консоли используя комманду вида:
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

# Данные для проверки

bastion_IP = 84.201.173.236

someinternalhost_IP = 10.128.0.24
