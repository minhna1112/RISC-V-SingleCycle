# RISC-V-SingleCycle
Project Digital Design II

## How to simulate:
1. Clone this repository
2. Open ModelSim and compile all of the _.v_ files
3. In ModelSim, click at the _riscv_soc_tb_ and simulate it ![image](https://user-images.githubusercontent.com/26354139/156257334-c4c8b5ab-081d-4ecc-9559-340cba7691f1.png)
4. Design is loaded successfully when the transcript shows something like this ![image](https://user-images.githubusercontent.com/26354139/156257516-38fc7e29-5467-4ed7-a624-1c4e67a71eea.png)
5. In transcript, type run 250, in order to simulate with 12 clock cycle, and see how values of registers and data_mem changes overtime.
6. You can add wave of riscv_soc_tb/rv32/id in order to see the changes of control signals ![image](https://user-images.githubusercontent.com/26354139/156257829-837e464d-0bb1-4e1d-b874-0efddd3b2419.png)


## How to synthesize:
1. Use Vivado
2. Take riscv.v as the top-level module for synthesis.
3. Note: Leave out inst_mem.v, data_mem,v, riscv_test.v, rischv_test_soc.v and other _.txt_ files 
