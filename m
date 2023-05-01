Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DBFCC77B73
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 May 2023 03:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2aNI7TZ0alD1HATAXpUFKJdujBARZOUkU5GLZT9uSAs=;
 b=O1dHl0kRGvsE+C2bA/DhpcOSAqiCWIrfJYnMFkx1WoKzRvEFtMo5ZbqEiRzv+Meo7EtFvmay1fi1
   7Ly2wH/B1/rTuifcnVJHmz4xULlI5wQxAQsljmxUmeC3GdH6LbwDstjMn2Tne2Bp/Lgk4przZ63y
   /nFB+Vn5FPSeFGmMqjmna1O+e3FGamATO0qWnr2X9tJL/spAoREYds/uYlVUUX6aHmJvb2MXEN/9
   u0UCpUvANuxr0UpKocYzKCzDuNGa2NNT14nlzi0G5TsrC/457ChmhBnGD8n0Zht/i+ERh9l72tni
   6/KggRIJoDpVpsjge5I/FUqK6jzocEPOIOEQpQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2aNI7TZ0alD1HATAXpUFKJdujBARZOUkU5GLZT9uSAs=;
 b=C9uMBQ1HbmITrKCndab2V4+kbfUGhZFB0uVmP4Z+ZWf/bG2HhVN0dEsYnbHmbFrBzwulorkb4RW1
   9YX8r6V0UcZk0jQXjPRSqaBFpz3QaogU9D8Kp+CVdlsHl2c8FJfhtrRZAQjXtJdOYLkEQlLiWhd2
   OXkgLT/2lNhq151fQbywQXS/+bB2sBmCm4ZPhIHknIMDLsDoI9AW78EhZVNfW6FIvmmxZOLwSfy0
   qn2V2TuSh2y9pTxViUkIqzxc6wnp4l/BTSjzSdg6VWsK48q+kxI58XGbQ3sqDOjwAy+7n4jFXAjh
   qe7v6sCfyMt/ZFQ4OGlFCa8x2h96moitYhn3tg==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RTY0046TMO227D0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 01 May 2023 03:21:38 +0000 (GMT)
Message-id: <2254db82-10cc-50a7-6cb9-5344e294a3eb@linux.alibaba.com>
Date: Mon, 1 May 2023 11:21:15 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>
References: <20230430031302.15597-1-heming.zhao@suse.com>
 <b2942f09-9797-220f-db72-3b49b0859277@linux.alibaba.com>
 <20230501022628.avrcx3exv3nev3fl@c73>
 <d9d1fc18-39d8-2888-c540-faac2d3f5628@linux.alibaba.com>
 <20230501030958.ps6xssjcvu6pnpnl@c73>
In-reply-to: <20230501030958.ps6xssjcvu6pnpnl@c73>
X-Source-IP: 115.124.30.101
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10696
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
 bulkscore=0 adultscore=0 spamscore=0 clxscore=64 malwarescore=0 suspectscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305010026 domainage_hfrom=8782
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 1/2] ocfs2: fix missing reset j_num_trans	for
 sync
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R421e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045168;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VhJ8vSG_1682911275;
X-ServerName: out30-101.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: HvTKSURLgFlVwojyP_mXO2Ix9EWi0oFX
X-Proofpoint-ORIG-GUID: HvTKSURLgFlVwojyP_mXO2Ix9EWi0oFX
Reporting-Meta:
 AAHtxFCqx2DP3sBkOse7NRIpNtDtbqKvunTbY3VBvywzlKICH0zUTD9hzbR00zNc
 59bQJZFDL81VZQHWXlQ+n8vB2gHiLba+fVaP/qIIHL80kFph1p7x7TuN0w0xSFrs
 S2WXK+UwA4KRLgqClxcsxPMDOdeYz5R896Oy6KyGJBjx3XxUCe93hfmI+JHUNGNO
 clk1ky/4Ux4vR9ZVyB2WNMGVdQGcor8zmRMOWuV0fp49k3StYkQzRj7D4RLq0Xq2
 Rvqgm3F03GVHuUU5ZC5VaysMIZC3Ha2MB1nnrPZxfjT2U+xHKr7Qi/2elzc1Ch3T
 biGcU2TApOhM1YfOkdv6eS3DUg+R8c7APmFihlvZwRbGNTFIWFPBoRw4Y1S9TurK
 lliMIgK0xxOzz3CxGptggd1oqyQPAME4e7EB5xozZNvogwx2onhR2en52ffyhgFO
 VtYyvFtHW86U9enbD63r88dPSLiFTwladzCk8mT8Gp3kGDTjWqIT3jodIVT2WDmW
 r7KQtMXjjgM1h4wHpHQEkGdFG830ynbKcXW2CHlI81Pa



On 5/1/23 11:09 AM, Heming Zhao wrote:
> On Mon, May 01, 2023 at 10:52:13AM +0800, Joseph Qi wrote:
>>
>>
>> On 5/1/23 10:26 AM, Heming Zhao wrote:
>>> On Mon, May 01, 2023 at 10:07:34AM +0800, Joseph Qi wrote:
>>>> Hi,
>>>>
>>>> What's the journal status in this case?
>>> jbd2 is marked with JBD2_ABORT
>>>
>>>> I wonder why commit thread is not working, which should flush journal
>>>> and reset j_num_trans during commit cache.
>>> The reason is in my above answer.
>>>
>>> below is the dmesg log for No. 266.
>>>
>>> ```
>>> [  595.071807] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: joining the lockspace group...
>>> [  595.080950] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
>>> [  595.081091] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1
>>> [  595.081580] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: add member 1
>>> [  595.081886] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_members 1 nodes
>>> [  595.082173] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: generation 1 slots 1 1:1
>>> [  595.082420] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory
>>> [  595.082696] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 in 0 new
>>> [  595.082932] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 out 0 messages
>>> [  595.083188] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1 generation 1 done: 0 ms
>>> [  595.084721] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: join complete
>>> [  595.095436] kernel: ocfs2: Mounting device (253,16) on (node 1, slot 0) with ordered data mode.
>>> [  595.787078] systemd[1]: Started /usr/bin/bash -c exit 77.
>>> [  595.802650] systemd[1]: fstests-check.scope: Deactivated successfully.
>>> [  596.195734] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: joining the lockspace group...
>>> [  596.206310] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: group event done 0
>>> [  596.206350] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover 1
>>> [  596.209667] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: add member 1
>>> [  596.211433] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_members 1 nodes
>>> [  596.213942] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: generation 1 slots 1 1:1
>>> [  596.215668] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory
>>> [  596.217171] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory 0 in 0 new
>>> [  596.218253] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory 0 out 0 messages
>>> [  596.219401] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover 1 generation 1 done: 0 ms
>>> [  596.220628] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: join complete
>>> [  596.224616] kernel: JBD2: Ignoring recovery information on journal
>>> [  596.229686] kernel: ocfs2: Mounting device (253,32) on (node 1, slot 0) with ordered data mode.
>>> [  596.870008] systemd[1]: fstest-scratch.mount: Deactivated successfully.
>>> [  596.236135] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: leaving the lockspace group...
>>> [  596.237431] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: group event done 0
>>> [  596.239442] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: release_lockspace final free
>>> [  596.877286] ocfs2_hb_ctl[5436]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u 78CE18109AE44E6AA896722A5E25CFC0
>>> [  596.248299] kernel: ocfs2: Unmounting device (253,32) on (node 1)
>>> [  596.255888] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: leaving the lockspace group...
>>> [  596.905718] systemd[1]: fstest-test.mount: Deactivated successfully.
>>> [  596.280602] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
>>> [  596.281762] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: release_lockspace final free
>>> [  596.921672] ocfs2_hb_ctl[5448]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u 838DD74847E34AA1839D6C4AA31132F1
>>> [  596.299507] kernel: ocfs2: Unmounting device (253,16) on (node 1)
>>> [  596.481755] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: joining the lockspace group...
>>> [  596.484722] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1
>>> [  596.484729] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
>>> [  596.485361] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: add member 1
>>> [  596.485622] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_members 1 nodes
>>> [  596.485861] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: generation 1 slots 1 1:1
>>> [  596.486063] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory
>>> [  596.486293] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 in 0 new
>>> [  596.486498] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 out 0 messages
>>> [  596.486768] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1 generation 1 done: 0 ms
>>> [  596.487037] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: join complete
>>> [  596.491655] kernel: ocfs2: Mounting device (253,16) on (node 1, slot 0) with ordered data mode.
>>> [  597.139758] root[5475]: run xfstest generic/266
>>> [  596.505896] unknown: run fstests generic/266 at 2023-05-01 10:19:02
>>> [  597.186885] systemd[1]: Started /usr/bin/bash -c test -w /proc/self/oom_score_adj && echo 250 > /proc/self/oom_score_adj; exec ./tests/generic/266.
>>> [  597.566466] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: joining the lockspace group...
>>> [  597.579759] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
>>> [  597.579766] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1
>>> [  597.581004] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: add member 1
>>> [  597.581820] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_members 1 nodes
>>> [  597.582292] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: generation 1 slots 1 1:1
>>> [  597.582894] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory
>>> [  597.583423] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 in 0 new
>>> [  597.583991] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 out 0 messages
>>> [  597.584547] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1 generation 1 done: 4 ms
>>> [  597.585079] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: join complete
>>> [  597.590136] kernel: JBD2: Ignoring recovery information on journal
>>> [  597.594258] kernel: ocfs2: Mounting device (253,32) on (node 1, slot 0) with ordered data mode.
>>> [  598.239046] systemd[1]: fstest-scratch.mount: Deactivated successfully.
>>> [  597.606575] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: leaving the lockspace group...
>>> [  597.607446] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
>>> [  598.244507] ocfs2_hb_ctl[5680]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u AB0245F740984C25A9D0907D61DFCF8A
>>> [  597.607843] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: release_lockspace final free
>>> [  597.615474] kernel: ocfs2: Unmounting device (253,32) on (node 1)
>>> [  597.641624] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: joining the lockspace group...
>>> [  597.659435] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1
>>> [  597.659479] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
>>> [  597.661482] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: add member 1
>>> [  597.662340] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_members 1 nodes
>>> [  597.663211] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: generation 1 slots 1 1:1
>>> [  597.664150] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory
>>> [  597.665466] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 in 0 new
>>> [  597.666370] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 out 0 messages
>>> [  597.667235] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1 generation 1 done: 0 ms
>>> [  597.668428] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: join complete
>>> [  600.194974] systemd[1]: Started Daily Cleanup of Snapper Snapshots.
>>> [  600.207227] dbus-daemon[672]: [system] Activating via systemd: service name='org.opensuse.Snapper' unit='snapperd.service' requested by ':1.10' (uid=0 pid=5728 comm="/usr/lib/snapper/systemd-helper --cleanup")
>>> [  600.209151] systemd[1]: Starting DBus interface for snapper...
>>> [  600.217270] dbus-daemon[672]: [system] Successfully activated service 'org.opensuse.Snapper'
>>> [  600.217370] systemd[1]: Started DBus interface for snapper.
>>> [  600.218969] systemd[1]: snapper-cleanup.service: Deactivated successfully.
>>> [  599.608010] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: joining the lockspace group...
>>> [  599.611041] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1
>>> [  599.611127] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
>>> [  599.611813] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: add member 1
>>> [  599.612019] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_members 1 nodes
>>> [  599.612227] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: generation 1 slots 1 1:1
>>> [  599.612397] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory
>>> [  599.612559] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 in 0 new
>>> [  599.612712] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 out 0 messages
>>> [  599.612880] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1 generation 1 done: 0 ms
>>> [  599.613078] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: join complete
>>> [  599.615320] kernel: JBD2: Ignoring recovery information on journal
>>> [  599.619221] kernel: ocfs2: Mounting device (254,0) on (node 1, slot 0) with ordered data mode.
>>> [  600.392044] systemd[1]: fstest-scratch.mount: Deactivated successfully.
>>> [  599.780111] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: leaving the lockspace group...
>>> [  599.781949] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
>>> [  599.784235] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: release_lockspace final free
>>> [  600.426136] ocfs2_hb_ctl[5762]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u F06626AE7D754F11A0211679C145C8BF
>>> [  599.808566] kernel: ocfs2: Unmounting device (254,0) on (node 1)
>>> [  599.827803] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: joining the lockspace group...
>>> [  599.832848] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1
>>> [  599.832984] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
>>> [  599.833810] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: add member 1
>>> [  599.834272] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_members 1 nodes
>>> [  599.834663] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: generation 1 slots 1 1:1
>>> [  599.835030] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory
>>> [  599.835474] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 in 0 new
>>> [  599.835868] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 out 0 messages
>>> [  599.836365] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1 generation 1 done: 4 ms
>>> [  599.836829] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: join complete
>>> [  599.845790] kernel: ocfs2: Mounting device (254,0) on (node 1, slot 0) with ordered data mode.
>>> [  600.079285] kernel: Buffer I/O error on dev dm-0, logical block 2621424, async page read
>>> [  600.090845] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
>>> [  600.091387] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
>>> [  600.091924] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
>>> [  600.092422] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
>>> [  600.094252] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
>>> [  600.095029] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
>>> [  600.095891] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
>>> [  600.096698] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
>>> [  600.099071] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
>>> [  600.099957] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
>>> [  600.100798] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
>>> [  600.101623] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
>>> [  600.107094] kernel: (xfs_io,5785,1):ocfs2_get_refcount_tree:358 ERROR: status = -5
>>> [  600.107659] kernel: (xfs_io,5785,1):ocfs2_lock_refcount_tree:456 ERROR: status = -5
>>> [  600.108175] kernel: (xfs_io,5785,1):ocfs2_refcount_cow_hunk:3417 ERROR: status = -5
>>> [  600.108654] kernel: (xfs_io,5785,1):ocfs2_refcount_cow:3478 ERROR: status = -5
>>> [  600.109128] kernel: (xfs_io,5785,1):ocfs2_prepare_inode_for_write:2326 ERROR: status = -5
>>> [  600.109613] kernel: (xfs_io,5785,1):ocfs2_file_write_iter:2433 ERROR: status = -5
>>> [  600.118113] kernel: (umount,5789,3):ocfs2_inode_lock_update:2354 ERROR: status = -5
>>> [  600.118481] kernel: (umount,5789,3):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
>>> [  600.118898] kernel: (umount,5789,3):ocfs2_statfs:1654 ERROR: status = -5
>>> [  600.119364] kernel: (umount,5789,3):ocfs2_statfs:1686 ERROR: status = -5
>>> [  600.759255] systemd[1]: fstest-scratch.mount: Deactivated successfully.
>>> [  600.127135] kernel: Buffer I/O error on dev dm-0, logical block 529, lost sync page write
>>> [  600.127373] kernel: JBD2: I/O error when updating journal superblock for dm-0-24.
>>> [  600.127615] kernel: Aborting journal on device dm-0-24.
>>> [  600.127893] kernel: Buffer I/O error on dev dm-0, logical block 529, lost sync page write
>>> [  600.128137] kernel: JBD2: I/O error when updating journal superblock for dm-0-24.
>>> [  600.128362] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> [  600.128591] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_thread:2346 ERROR: status = -5, journal is already aborted.
>>> [  601.147704] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> [  602.171745] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> [  603.195707] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> [  604.219709] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> [  605.243712] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> [  606.267748] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> [  607.291715] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> [  608.315742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> [  609.339724] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> [  610.363774] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> [  611.387693] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> [  612.411727] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> [  613.435719] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> [  614.459743] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> [  615.483742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> [  615.484503] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_thread:2346 ERROR: status = -5, journal is already aborted.
>>> [  616.507742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> [  617.531751] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> [  618.555743] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> [  619.579702] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> [  620.603758] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
>>> ^C
>>> tb-fstest1:/usr/src/linux/fs/ocfs2 #
>>> ```
>>
>> So the case is, flush journal in commit thread will never end if journal
>> is abort, and then lead to umount hang since commit thread won't stop,
>> right?
> Yes.
> 
>>
>> If so, I don't think your changes in sync fs is a right solution. It
>> seems it just for bypassing the testcase.
> No. 
> In my view, No. 266 shouldn't trigger jbd2 ABORT status. The 'sync' should
> tidy up all already issued write IOs. After sync & load dm-error, new write IOs
> fails on rw IOs, which shouldn't generate any journal IOs and shouldn't trigger
> jbd2 to enter ABORT status.
> 

What if there is no 'sync' in this case?

>>
>> If the expected behavior is to let umount ends even journal is abort,
>> it seems we have to make journal shutdown happy in this case.
> This is my [patch 2/2] job, which resolves fstest generaic NO. 347 361 628 629.
> 
> - Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
