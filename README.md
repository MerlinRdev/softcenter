# Softcenter for MIPS

本软件中心是基于mips平台路由器的软件中心,适用于linux内核为3.10.104的mips架构的路由器！

## 兼容机型

支持的机型：
1. 华硕 `BLUECAVE`
2. 网件 `RAX40` `RAX35`
3. 斐讯 `K3C`

## 开发须知：

如果你是开发者，想要开发新的插件，并用离线包的方式进行传播，请了解以下内容：

1. 在程序方面：由于固件采用了版本为3.10.104的linux内核，和mips的编译器，所以请确保你编译的程序是mips架构的。

**软件中心各架构列表：**

|  软件中心   |                        mips软件中心                        |                 arm软件中心                  |                      hnd/axhnd软件中心                       |                    armng软件中心                    |            mipsle软件中心             |
| :---------: | :----------------------------------------------------------: | :---------------------------------------------: | :----------------------------------------------------------: | :-----------------------------------------------: |:-----------------------------------------------: |
|  项目名称   | [softcenter](https://github.com/paldier/softcenter) | [softcenterarm](https://github.com/paldier/softcenterarm) |       [softcenterarm64](https://github.com/paldier/softcenterarm64)        | [softcenterarmng](https://github.com/paldier/softcenterarmng) |[softcentermipsle](https://github.com/paldier/softcentermipsle) |
|  适用架构   |                            mips                            |                     armv7l                      |                       aarch64                     |                        armv7l                        |                mipsle             |
|    平台     |                             mips                              |                       arm                       |                          hnd/axhnd                           |                     arm                      |            mipsle             |
|  linux内核  |               3.10.104                |                2.6.36.4/3.14             |             4.1.27/4.1.51            |             4.1.49/4.1.52            |         3.10.14          |
|     CPU     |                          grx500                           |                    bcm4708/9/ipq4019                    |                          bcm4906/8                           |                     bcm6750/1/2/3/4/5                     |               mtk7621
|  固件版本   |                    MerlinR 5.0.0                     |              MerlinR 5.0.0              |                     MerlinR 5.0.0                      |                  MerlinR 5.0.0                    |                MerlinR 5.0.0                    |
| 软件中心api |                          **1.1** 代                          |                   **1.1** 代                    |                          **1.1** 代                          |                    **1.1** 代                     |                **1.1** 代                     |
| 代表机型-1  | [BLUECAVE](https://github.com/paldier/bluecave-merlin) |              [RT-AC68U](https://github.com/paldier/rtac68u)               | [RT-AC86U](https://github.com/paldier/86u-merlin) |                         TUF-AX3000                        |          [RT-AC85P](https://github.com/paldier/ac85p-merlin) | 
| 代表机型-2  | [K3C](https://github.com/paldier/K3C-merlin) |              [K3](https://github.com/paldier/K3-merlin.ng)              | [GT-AC2900](https://github.com/paldier/gt-ac2900) |                         RT-AX58U                        |         RT-ACRH26
| 代表机型-3  | [RAX40](https://github.com/paldier/rax40-merlin) |         [SBRAC1900P](https://github.com/paldier/sbrac1900p-merlin)                                        | [R8000P](https://github.com/paldier/r8000p-merlin) |                        RAX20                         |         TUF-AC1750         |
| 代表机型-4  | DIR2680 |  [RT-ACRH17](https://github.com/paldier/acrh17-merlin)                              | RAX80 |                        RT-AX56U                         |            /              |


