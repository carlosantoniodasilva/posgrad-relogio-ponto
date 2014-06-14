# Relogio Ponto

Projeto e implementação de um software para relógio ponto.

Trabalho Final Módulo 2 - Pós Graduação em Engenharia de Software - UDESC

## Setup de desenvolvimento

Verifique se possui os requisitos e versões necessários:

* *Git*: para fazer o clone do repositório, qualquer versão mais atual.
* *Ruby*: ver arquivo .ruby-version.
* *Bundler*: gem para instalar as dependências, instale com `gem install bundler`.
* *PostgreSQL*: banco de dados, versão 9.2+.

Para instalar a aplicação localmente, faça clone do repositório:

```bash
$ git clone https://github.com/carlosantoniodasilva/posgrad-relogio-ponto.git
```

Depois basta acessar o diretório clonado e rodar os comandos abaixo para instalar as dependências e setar o banco de dados.

```bash
$ cd posgrad-relogio-ponto
$ bundle install
$ bin/rake db:setup
```

O comando `db:setup` vai também criar um usuário administrador, verifique o arquivo `db/seeds.rb` para obter as credenciais de acesso.

Agora basta rodar o servidor do rails com `bin/rails server` e testar a aplicação em `localhost:3000`.

## Validação

A app está disponível para validação em [http://udesc-ponto.herokuapp.com/](http://udesc-ponto.herokuapp.com/).

## Deploy

Para fazer deploy da app para o heroku é necessário utilizar o `git subtree`, pois a app está em um subdiretório, e não no root do repositório:

```bash
$ git subtree push --prefix ponto heroku master
```

Para sobrescrever algum commit lá não é possível usar `subtree` com `force`, já que ele não suporta esse comando. Nesse caso é necessário usar o `git push --force` e aninhar o comando `git subtree split` para obter os commits a serem enviados para o heroku:

```bash
$ git push -f heroku `git subtree split --prefix ponto master`:master
```

Créditos: [https://coderwall.com/p/ssxp5q](https://coderwall.com/p/ssxp5q).

## Testes

A suite de testes da aplicação está rodando no travis-ci, um serviço de build
contínuo gratuito para projetos open source:

[![Status do build](https://api.travis-ci.org/carlosantoniodasilva/posgrad-relogio-ponto.svg?branch=master)](https://travis-ci.org/carlosantoniodasilva/posgrad-relogio-ponto)


## Participantes

* Ademar Perfoll Junior ([@juniorperfoll](https://github.com/juniorperfoll))
* Carlos Antonio da Silva ([@carlosantoniodasilva](https://github.com/carlosantoniodasilva))
* Fabrício Reif ([@fabricioreif](https://github.com/fabricioreif))
* Professor: Nilson Modro ([@nilsonmodro](https://github.com/nilsonmodro))

## License

MIT-LICENSE
