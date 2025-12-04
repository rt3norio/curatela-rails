# Curatela Legal Rails

Aplicação Rails completa com autenticação, gestão de usuários, upload de arquivos e foto de perfil.

## Características

- ✅ **Rails 8.1.1** - Versão mais recente do Rails
- ✅ **Ruby 3.3+** - Versão mais recente do Ruby
- ✅ **SQLite** - Banco de dados para desenvolvimento
- ✅ **Devise** - Sistema de autenticação completo
- ✅ **Active Storage** - Upload de arquivos e fotos de perfil
- ✅ **DevContainer** - Ambiente de desenvolvimento isolado

## Pré-requisitos

- Docker Desktop (para usar DevContainer)
- VS Code com extensão "Dev Containers"

## Configuração do Ambiente

### Usando DevContainer (Recomendado)

1. Abra o projeto no VS Code
2. Pressione `F1` ou `Ctrl+Shift+P` e selecione "Dev Containers: Reopen in Container"
3. Aguarde a construção do container e instalação das dependências
4. Execute as migrações:
   ```bash
   rails db:create db:migrate
   ```
5. Inicie o servidor:
   ```bash
   rails server
   ```

### Desenvolvimento Local (Windows)

**Nota:** No Windows, algumas gems podem ter problemas de compilação. Recomendamos usar o DevContainer.

Se preferir desenvolver localmente:

1. Instale o Ruby 3.3+ e Rails 8.1+
2. Execute:
   ```bash
   bundle install
   rails db:create db:migrate
   rails server
   ```

## Estrutura do Projeto

### Autenticação

- **Devise** configurado com módulos:
  - `database_authenticatable` - Login com email/senha
  - `registerable` - Registro de novos usuários
  - `recoverable` - Recuperação de senha
  - `rememberable` - Lembrar sessão
  - `validatable` - Validações de email e senha

### Gestão de Usuários

- Listagem de todos os usuários (`/users`)
- Visualização de perfil (`/users/:id`)
- Edição de perfil próprio (`/users/:id/edit`)
- Upload de foto de perfil

### Rotas Principais

- `/` - Lista de usuários (requer autenticação)
- `/users` - Lista de usuários
- `/users/:id` - Perfil do usuário
- `/users/:id/edit` - Editar perfil (apenas próprio)
- `/users/sign_in` - Login
- `/users/sign_up` - Registro
- `/users/sign_out` - Logout

## Banco de Dados

O projeto usa SQLite por padrão. As migrações incluem:

1. Tabela `users` (Devise)
2. Tabelas do Active Storage (`active_storage_blobs`, `active_storage_attachments`, `active_storage_variant_records`)

### Executar Migrações

```bash
rails db:create db:migrate
```

### Reset do Banco de Dados

```bash
rails db:drop db:create db:migrate
```

## Desenvolvimento

### Iniciar o Servidor

```bash
rails server
# ou
rails s
```

A aplicação estará disponível em `http://localhost:3000`

### Console do Rails

```bash
rails console
# ou
rails c
```

### Testes

```bash
rails test
```

## Funcionalidades Implementadas

### Autenticação
- ✅ Login/Logout
- ✅ Registro de novos usuários
- ✅ Recuperação de senha
- ✅ Lembrar sessão

### Gestão de Usuários
- ✅ Listagem de usuários
- ✅ Visualização de perfil
- ✅ Edição de perfil (apenas próprio)
- ✅ Upload de foto de perfil
- ✅ Validações de segurança

### Interface
- ✅ Layout responsivo
- ✅ Navegação entre páginas
- ✅ Mensagens de sucesso/erro
- ✅ Exibição de fotos de perfil

## Próximos Passos

O projeto está pronto para evoluir. Algumas sugestões:

- Adicionar mais campos ao modelo User (nome, telefone, etc.)
- Implementar roles/permissões
- Adicionar busca e filtros na listagem de usuários
- Melhorar o design com CSS framework (Bootstrap, Tailwind, etc.)
- Adicionar testes automatizados
- Implementar paginação
- Adicionar validações de imagem (tamanho, formato)

## Tecnologias Utilizadas

- **Ruby** 3.3+
- **Rails** 8.1.1
- **SQLite** 3
- **Devise** - Autenticação
- **Active Storage** - Upload de arquivos
- **Docker** - Containerização

## Licença

Este projeto está pronto para desenvolvimento.
