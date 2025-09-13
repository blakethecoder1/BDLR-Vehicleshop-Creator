# BDLR-Vehicleshop-Creator
Vehicleshop Creator (QBCore + ox_lib)

Overview

A complete, easy-to-install Vehicle Shop Creator resource for QBCore servers using ox_lib and MySQL (oxmysql/ghmattimysql). Designed for admins to create in-world vehicle shops that players can browse, test-drive, and purchase. Includes server-side validation, DB persistence, rate-limiting, and integration hooks for common vehicle ownership/key systems.

Highlights

- In-game admin creator (command + SHIFT+E) to place shops quickly
- Map blips, markers, and an in-game shop menu using ox_lib
- Purchase flow with server validation and money removal (supports cash/bank)
- Spawns purchased vehicle with generated plate and attempts to save ownership
- MySQL persistence and automatic table creation (configurable)
- Exports and callbacks for other resources to interact with shops
- Admin commands for create/list/delete
- Hooks for qb-vehiclekeys and common owned_vehicles tables

Requirements

- QBCore (v2+ recommended)
- ox_lib (for menus / dialogs / notifications)
- One of: oxmysql or ghmattimysql/mysql-async (recommended oxmysql)
- Optional: qb-vehiclekeys (for giving vehicle keys)

Installation

1. Place the resource folder in your resources directory (e.g., resources/[local]/vehicleshop)
2. Ensure fxmanifest.lua is present and resource name matches folder name
3. Add to server.cfg:
   ensure vehicleshop
4. Install dependencies if you don't already have them:
   - QBCore
   - ox_lib
   - oxmysql or ghmattimysql
   - qb-vehiclekeys (optional)

Configuration

Open config.lua (or server/main.lua references) to edit defaults. Important options:

- Config.UseMySQL (true/false) — enable DB persistence
- Config.TableName — DB table name for shops (default: vehicleshops)
- Config.AdminJob / Config.UseACE / Config.ACEGroup — control admin permission checks
- Config.DefaultBlip — default blip settings for created shops
- Config.SpawnOffset — local offset used when creating a spawn point
- Config.ExampleVehicles — example vehicles added by default when creating a shop
- Config.PlateFormat — plate string format used when generating plates
- Config.RateLimit — milliseconds between admin create attempts to prevent spam

If you want the resource to auto-create the DB table, set Config.UseMySQL = true and ensure your server has oxmysql or ghmattimysql configured properly.

MySQL Schema

If you prefer to create the table manually, run the included qb-shops.sql (adjust table name if necessary):

CREATE TABLE IF NOT EXISTS vehicleshops (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    coords JSON NOT NULL,
    spawn JSON NOT NULL,
    blip JSON DEFAULT NULL,
    data JSON NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

Usage

Admin Controls

- /vehicleshop create — opens the creator input (also Shift+E triggers an open request in-game while near a shop marker).
- /vehicleshop list — lists existing shops in chat
- /vehicleshop delete <id> — deletes a shop by ID

Creator Flow (recommended)

1. Stand where you want the shop marker (where players will open the shop)
2. Press SHIFT+E (or run /vehicleshop create). A dialog will ask for the shop name.
3. The resource saves a shop using your current coords, spawn offset and default vehicles (you can edit the data later in DB or extend the UI to add custom vehicles)
4. A blip appears on the map for players

Player Flow

1. Players walk to a shop marker and press E
2. ox_lib context menu shows available vehicles with price
3. Player confirms purchase via alert dialog
4. Server validates funds and removes money (cash/bank). On success:
   - A plate is generated
   - Ownership save is attempted (best-effort; adjust to your server schema)
   - Client spawns vehicle and assigns plate
   - Vehicle key hook is called if qb-vehiclekeys is present

Events & Callbacks (for devs)

Client callbacks and events:
- lib.callback('vehicleshop:getShops') — returns all shops
- TriggerServerEvent('vehicleshop:buyVehicle', shopId, vehicleData) — purchase request
- RegisterNetEvent('vehicleshop:purchaseSuccess') — client event when purchase completes (spawns vehicle)
- RegisterNetEvent('vehicleshop:openCreator') — triggers in-game creator input on client

Server callbacks/exports:
- QBCore.Functions.CreateCallback('vehicleshop:createShop', source, cb, data) — create shop (admin only)
- QBCore.Functions.CreateCallback('vehicleshop:getShops', source, cb) — get shops
- QBCore.Functions.CreateCallback('vehicleshop:deleteShop', source, cb, shopId) — delete shop (admin only)
- exports('GetShops') — returns table of shops
- exports('CreateShop', data) — programmatically create a shop (returns { success = bool, res = shop_or_err })

Customization & Integration Notes

- Ownership saving: The server attempts a best-effort insert into common vehicle tables. Most servers use a custom owned_vehicles schema. Adapt server/main.lua saveOwnedVehicle() to match your schema (including vehicle JSON, mods, metadata).

- Plate uniqueness: Current plate generation is random. If you need fully-unique plates, modify server/main.lua to check your vehicle ownership table before finalizing a plate.

- Keys: The client tries to call exports['qb-vehiclekeys']:SetVehicleOwner(plate). Change this to match your key resource API or emit an event you handle.

- Test Drive: A test-drive system placeholder exists. If you'd like a timed test-drive with deposit/refund and forced vehicle removal and respawn, I can implement a fully-featured system.

Security & Best Practices

- All purchase verification and money removal happens server-side. Do not trust client inputs.
- Rate-limiting prevents admins from spamming shop creation.
- Sanitize any additional input you add if you expose more UI for editing vehicles/prices.

Troubleshooting

- I see no shops on server start:
  - Ensure Config.UseMySQL is correct and DB credentials are working.
  - Check server console for SQL errors. The resource attempts to create the table on resource start if UseMySQL is enabled.

- Purchases fail but money removed:
  - Verify server/main.lua buy flow. Money removal and ownership save are sequential. Check logs and adjust to your ownership schema.

- Keys not given:
  - Ensure qb-vehiclekeys is installed and exposes SetVehicleOwner. If not, adapt the call in client/main.lua.

Extending the Resource

- NUI Storefront: For a polished UI, replace ox_lib context menus with a custom NUI. I can provide a starter NUI when requested.
- Vehicle editing UI: Add an admin UI to edit shop data (add/remove vehicles, change prices) and persist changes to the DB.
- Test drive system: timed drives, automatic vehicle deletion, deposit handling and return-to-shop logic.

Support & Contact

If you need help adapting ownership save logic, adding NUI, or implementing test drives, tell me what owned_vehicles schema you use and whether you want deposit-based test drives. I can update the resource surgically to match your server.

License

Use and modify freely. Attribution appreciated but not required.

Changelog (v1)

- Initial release: admin creator, shop menu, DB persistence, purchase spawn + plate generation, basic ownership hook, ox_lib integration

