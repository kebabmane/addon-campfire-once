# Campfire Home Assistant Add-on

This Home Assistant add-on packages [Basecamp's Once Campfire](https://github.com/basecamp/once-campfire) chat application for easy deployment within your Home Assistant ecosystem.

## About

Campfire is an open-source web-based chat application that provides:

- Multiple chat rooms with access controls
- Direct messaging
- File attachments with previews
- Search functionality
- Web Push notifications
- @mentions support
- Bot integration via API

## Installation

1. Add this repository to your Home Assistant Supervisor:
   - Go to **Supervisor** → **Add-on Store** → **⋮** → **Repositories**
   - Add: `https://github.com/kebabmane/addon-campfire-once`

2. Install the "Campfire" add-on

3. Configure the add-on (see Configuration section below)

4. Start the add-on

## Configuration

The add-on can be configured through the Home Assistant interface. Here are the available options:

### Basic Options

- **domain**: The domain name for your Campfire instance (default: "localhost")
- **ssl**: Enable SSL/HTTPS (default: true)
- **admin_password**: Password for the admin user (required for first setup)
- **secret_key_base**: Rails secret key (auto-generated if not provided)

### SSL Options (when SSL is enabled)

- **certfile**: SSL certificate file name in `/ssl/` directory (default: "fullchain.pem")
- **keyfile**: SSL private key file name in `/ssl/` directory (default: "privkey.pem")

### Database Options

- **database_url**: Database connection string (default: SQLite in `/data/` directory)

### Example Configuration

```yaml
domain: "chat.yourdomain.com"
ssl: true
certfile: "fullchain.pem"
keyfile: "privkey.pem"
admin_password: "your-secure-admin-password"
secret_key_base: "your-secret-key-base"
database_url: ""  # Leave empty for default SQLite
```

## Usage

1. After starting the add-on, access Campfire through:
   - Home Assistant Ingress (recommended)
   - Direct URL: `http://your-ha-ip:3000` (or `https://` if SSL enabled)

2. Login with:
   - Email: `admin@yourdomain.com` (using the domain you configured)
   - Password: The admin_password you set in configuration

3. Create chat rooms and invite users to start collaborating

## Data Persistence

The add-on stores data in the `/data/` directory, which persists across container restarts:
- Database file (if using SQLite)
- Uploaded files and attachments
- Application logs

## SSL Setup

For SSL support, place your certificate files in the Home Assistant `/ssl/` directory:
- Certificate: `/ssl/fullchain.pem`
- Private key: `/ssl/privkey.pem`

You can obtain certificates from Let's Encrypt using the Let's Encrypt add-on.

## Networking

The add-on exposes port 3000 and includes:
- Home Assistant Ingress support for secure access
- WebUI integration for easy navigation
- Health checks for monitoring

## Troubleshooting

### Common Issues

1. **Add-on won't start**: Check the logs for error messages, ensure admin_password is set
2. **Can't access via Ingress**: Verify the add-on is running and ingress is enabled
3. **SSL issues**: Verify certificate files exist in `/ssl/` and are valid
4. **Database errors**: Check `/data/` directory permissions and available disk space

### Logs

View add-on logs through:
- Home Assistant → Supervisor → Campfire → Log tab
- Or use the CLI: `ha addons logs campfire`

## Support

For issues specific to this Home Assistant add-on, please create an issue in this repository.
For Campfire application issues, refer to the [original Campfire repository](https://github.com/basecamp/once-campfire).

## License

This add-on follows the same license as the original Campfire project.