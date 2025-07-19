const { Web3 } = require('web3');

const web3 = new Web3('https://xyberchain-rpc.xyz/');

async function testTransaction() {
    console.log('🧪 Testing XYBERCHAIN Transaction...');
    
    const privateKey = '4f3edf983ac636a65a842ce7c78d9aa706d3b113bce9c46f30d7d21715b23b1d';
    const fromAddress = '0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1';
    const toAddress = '0xffcf8fdee72ac11b5c542428b35eef5769c409f0';
    
    try {
        // Check balance
        const balance = await web3.eth.getBalance(fromAddress);
        console.log('💰 Balance:', web3.utils.fromWei(balance, 'ether'), 'XYB');
        
        // Get nonce
        const nonce = await web3.eth.getTransactionCount(fromAddress);
        console.log('🔢 Nonce:', nonce);
        
        // Get gas price
        const gasPrice = await web3.eth.getGasPrice();
        console.log('⛽ Gas Price:', gasPrice);
        
        // Create transaction
        const tx = {
            from: fromAddress,
            to: toAddress,
            value: web3.utils.toWei('1', 'ether'),
            gas: 21000,
            gasPrice: gasPrice,
            nonce: nonce
        };
        
        console.log('📝 Transaction:', tx);
        
        // Sign and send
        const signedTx = await web3.eth.accounts.signTransaction(tx, privateKey);
        console.log('✍️ Signed transaction');
        
        const receipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);
        console.log('✅ Transaction successful!');
        console.log('📋 Receipt:', receipt);
        
    } catch (error) {
        console.error('❌ Transaction failed:', error.message);
        
        // Additional debugging
        if (error.message.includes('insufficient funds')) {
            console.log('💡 Issue: Insufficient funds for gas');
        } else if (error.message.includes('nonce')) {
            console.log('💡 Issue: Nonce problem');
        } else if (error.message.includes('gas')) {
            console.log('💡 Issue: Gas estimation problem');
        }
    }
}

testTransaction();
