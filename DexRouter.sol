// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IUniswapV2Router {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}

contract DexRouter {
    address public owner;
    address public feeCollector;
    address public uniswapRouter;
    uint public feeBP = 30; // 0.3% fee

    constructor(address _feeCollector, address _router) {
        owner = msg.sender;
        feeCollector = _feeCollector;
        uniswapRouter = _router;
    }

    function swap(address tokenIn, address tokenOut, uint amountIn) external {
        require(amountIn > 0, "Amount must be > 0");

        uint fee = (amountIn * feeBP) / 10000;
        uint amountAfterFee = amountIn - fee;

        // Take fee
        IERC20(tokenIn).transferFrom(msg.sender, feeCollector, fee);

        // Take swap amount
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountAfterFee);

        // Approve Uniswap
        IERC20(tokenIn).approve(uniswapRouter, amountAfterFee);

        address ;
        path[0] = tokenIn;
        path[1] = tokenOut;

        IUniswapV2Router(uniswapRouter).swapExactTokensForTokens(
            amountAfterFee,
            0,
            path,
            msg.sender,
            block.timestamp
        );
    }

    function updateFee(uint _feeBP) external {
        require(msg.sender == owner, "Not owner");
        require(_feeBP <= 1000, "Max 10%");
        feeBP = _feeBP;
    }
}