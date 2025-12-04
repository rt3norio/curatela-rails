# Guia de Configuração Rápida

## Primeira Execução

### 1. Usando DevContainer (Recomendado)

1. Abra o projeto no VS Code
2. Quando solicitado, clique em "Reopen in Container"
   - Ou pressione `F1` e selecione "Dev Containers: Reopen in Container"
3. Aguarde a construção do container (pode levar alguns minutos na primeira vez)
4. O `postCreateCommand` executará automaticamente:
   - `bundle install` (instalação de gems)
   - `rails db:create db:migrate` (criação e migração do banco)

**Se você já tentou abrir antes e teve erro:**
- Pressione `F1` → "Dev Containers: Rebuild Container"
- Isso reconstruirá o container com as configurações corretas

### 2. Iniciar o Servidor

Após o container estar pronto, execute:

```bash
rails server
```

Ou simplesmente:

```bash
rails s
```

A aplicação estará disponível em: `http://localhost:3000`

### 3. Criar Primeiro Usuário

1. Acesse `http://localhost:3000`
2. Clique em "Registrar" no menu
3. Preencha email e senha
4. Faça login

## Comandos Úteis

### Banco de Dados

```bash
# Criar banco de dados
rails db:create

# Executar migrações
rails db:migrate

# Reset completo do banco
rails db:drop db:create db:migrate

# Ver status das migrações
rails db:migrate:status
```

### Console do Rails

```bash
rails console
# ou
rails c
```

No console, você pode criar usuários manualmente:

```ruby
User.create!(email: "admin@example.com", password: "password123")
```

### Testes

```bash
rails test
```

## Estrutura de Arquivos Importantes

- `app/models/user.rb` - Modelo de usuário com Devise e Active Storage
- `app/controllers/users_controller.rb` - Controller de gestão de usuários
- `app/views/users/` - Views de listagem, visualização e edição
- `app/views/devise/` - Views de autenticação (login, registro)
- `config/routes.rb` - Rotas da aplicação
- `config/initializers/devise.rb` - Configuração do Devise
- `db/migrate/` - Migrações do banco de dados

## Solução de Problemas

### Erro ao instalar gems no Windows

Use o DevContainer. O ambiente Docker resolve problemas de compilação de extensões nativas.

### Erro de permissão no banco de dados

```bash
chmod 755 db
chmod 644 db/*.sqlite3
```

### Resetar tudo

```bash
# Dentro do container
rails db:drop db:create db:migrate
rm -rf storage/*
```

## Próximos Passos

1. ✅ Autenticação configurada
2. ✅ Gestão de usuários funcionando
3. ✅ Upload de fotos de perfil
4. 🔄 Adicionar mais campos ao usuário (nome, telefone, etc.)
5. 🔄 Melhorar design com CSS framework
6. 🔄 Adicionar testes
7. 🔄 Implementar roles/permissões


