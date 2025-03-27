module MyModule::SimpleVault {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a personal vault
    struct Vault has key, store {
        balance: u64,
    }

    /// Initialize Vault for the account
    public fun init_vault(account: &signer) {
        assert!(!exists<Vault>(signer::address_of(account)), 1);
        move_to(account, Vault { balance: 0 });
    }

    /// Deposit coins into the vault
    public fun deposit(account: &signer, amount: u64) acquires Vault {
        let vault = borrow_global_mut<Vault>(signer::address_of(account));
        let coins = coin::withdraw<AptosCoin>(account, amount);
        // The coins are just stored logically, not actually held by Vault struct
        vault.balance = vault.balance + amount;
    }

    /// Withdraw coins from the vault
    public fun withdraw(account: &signer, amount: u64) acquires Vault {
        let vault = borrow_global_mut<Vault>(signer::address_of(account));
        assert!(vault.balance >= amount, 2);
        vault.balance = vault.balance - amount;
        let coins = coin::mint<AptosCoin>(amount);
        coin::deposit<AptosCoin>(signer::address_of(account), coins);
    }
}
