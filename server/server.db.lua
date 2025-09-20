local function initialize()
    local queries = {
        [[
CREATE TABLE IF NOT EXISTS `keep_bags_outfit` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(255) NOT NULL,
  `outfit_name` VARCHAR(255) NOT NULL,
  `metadata` TEXT NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8mb4;
         ]]
    }

    for _, query in ipairs(queries) do
        local affectedRows = MySQL.query.await(query, {})
        if affectedRows then
            print("^2[keep-bags] -> Database table initialized.^0")
        else
            print("^1[keep-bags] -> Failed to initialize the database table.^0")
        end
    end
end

CreateThread(initialize)
