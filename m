Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4C60C43334
	for <ocfs2-devel@archiver.kernel.org>; Sat, 18 Jun 2022 02:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sjoRsgB+hEw+V/zOOcKvFpzcKjZgH48RRjW+FhENzJo=;
 b=u8whKZUUWOhnD/2BUwh7oYkuIfWeDDEemUoRXf+srgSppubYqSGaYIap9+mX2048hXsFUvMclXi0
   KjWz0ZTHKn4W24Od/Ogr0l/ot2ae0LFI8XWOm5utKNKrbHExi91K2p/Wivx+AaTbeZKiYyOjWwQ7
   GEvWsl+thETHwnxEqKKoppSelsBG/YZOnrZa+8dBFIG4jmuupz32dYlNkz5uSjU7gHBu9WBf3eTi
   u02W0zXaJc8mf5UTKMTXwhSPU8+c6Pc27fMtnlZN4B5Lmu12eeckFBte3B1XcZ0KKg6+wvjM+6k6
   97KUkiJDsXqPqUTjGv6IqYMl2wtDET2TZJ4t6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sjoRsgB+hEw+V/zOOcKvFpzcKjZgH48RRjW+FhENzJo=;
 b=ATEIBNz+JaoEkZ5zDjl7WpK3HriOUz47IMaq9UGUDvgyBY4SoctIJ3ZkPxB0F/vIbSQNMi2cMF7d
   0ejVthQCfPg5KIbw/ptqB2SfxuF25ktwefpAbG+VZhvm0UCZhdb2Q5zIf8IkeJF2aH7K3pCdH7Wu
   7VQYyWFuY8tg4o453plQQ1PF0Z3uYLamlOVelie+JydaYYj+uosGCwQl/P4RI2bNmsd3UOxTWJ6W
   BfBZM2QUazcUf+zbyXoNcOimaUHYwqUZAPPdg2yXW1V/nVh7BOXUDVHnUvrz0QecCFgvxtVbm4yV
   Q4wQQ0Ur+50KhEIFPrBTX9fwnQljVULTD3450w==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220531 64bit (built May 31
 2022))
 with ESMTPS id <0RDN00A1AJ7OVCE0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 18 Jun 2022 02:35:48 +0000 (GMT)
Message-id: <3144cb10-4359-bb1e-1875-f9803fc9f4a9@linux.alibaba.com>
Date: Sat, 18 Jun 2022 10:35:22 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220608104808.18130-1-heming.zhao@suse.com>
In-reply-to: <20220608104808.18130-1-heming.zhao@suse.com>
X-Source-IP: 115.124.30.56
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10381
 signatures=594854
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 impostorscore=0 adultscore=0 mlxscore=0 clxscore=101 priorityscore=30
 phishscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206180010 domainage_hfrom=8465
Subject: Re: [Ocfs2-devel] [PATCH 0/1] test case for patch 1/1
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R331e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046051;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VGhwmEj_1655519723;
X-ServerName: out30-56.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: OWbWD6A6jerfsKHOrVUa0RLQgNlw3wOf
X-Proofpoint-GUID: OWbWD6A6jerfsKHOrVUa0RLQgNlw3wOf
Reporting-Meta:
 AAFniAupc05a3JcsQOjkLNKOki8UWMcjiz/IGsftpHhrZ88Z/ydY0izFEYePcb96
 4doZNlJymMlADPo0BbPM4gsc+2Q7rFajR2UH2La9rCDHqJ4ghttqnEdG/2H/9/3M
 HWEHuGt8KOBIZTfOeLtif86B5CytqUlo5IeFDjY9YfgcvuL11AvPpJWozovbhziE
 sU+2lpSj8h0ppuMJKv/cdNaYr94UFCtf7lBenscm43BmaRkWtufQld9QPdXhAB9D
 6hdP/MfLBgEGVISUlHC6QQkeyQSWocF9GgW19tFyF3XYlZSu2VA3ujOBTyLQ4DnR
 /eI282rphNdg9Y0r6YHRZq4qSEtZOfVPc7WnfikkYBQY/hnSg5boNI61f4w7NPR2
 irKUP81KOoKCCWRJgXuBncLi811Zd9FEaWW53wjBXYUQXYtd3Nv7SlUCYaux6mWt
 J520cbFtuY88xRlHKVopF0sZHTmdImlk3IT03FfSKTQb1Ig8vtL+YNZUTEGQBiSD
 I9QmZRfWO/upFLyxr8lyP2XXYTpfxxzyFRq1Lqj9cxsUiQ==



On 6/8/22 6:48 PM, Heming Zhao wrote:
> === test cases ====
> 
> <1> remount on local node for cluster env
> 
> mount -t ocfs2 /dev/vdb /mnt
> mount -t ocfs2 /dev/vdb /mnt              <=== failure
> mount -t ocfs2 -o nocluster /dev/vdb /mnt <=== failure
> 

This is mount multiple times, not remount.
Don't get it has any relations with your changes.

> <2> remount on local node for nocluster env
> 
> mount -t ocfs2 -o nocluster /dev/vdb /mnt
> mount -t ocfs2 /dev/vdb /mnt              <=== failure
> mount -t ocfs2 -o nocluster /dev/vdb /mnt <=== failure
> 
> <3> remount on another node for cluster env
> 
> node2:
> mount -t ocfs2 /dev/vdb /mnt
> 
> node1:
> mount -t ocfs2 /dev/vdb /mnt  <== success
> umount
> mount -t ocfs2 -o nocluster /dev/vdb /mnt <== failure
> 
> <4> remount on another node for nocluster env
> 
> node2:
> mount -t ocfs2 -o nocluster /dev/vdb /mnt
> 
> node1:
> mount -t ocfs2 /dev/vdb /mnt              <== failure
> mount -t ocfs2 -o nocluster /dev/vdb /mnt <== success, see below comment
> 
Why allow two nodes mount nocluster sucessfully?
Since there is no cluster lock enabled, it will corrupt data.

> <5> simulate after crash status for cluster env
> 
> (below all steps did on node1. node2 is unmount status)
> mount -t ocfs2 /dev/vdb /mnt
> dd if=/dev/vdb bs=1 count=8 skip=76058624 of=/root/slotmap.cluster.mnted
> umount /mnt
> dd if=/root/slotmap.cluster.mnted of=/dev/vdb seek=76058624 bs=1 count=8
> mount -t ocfs2 -o nocluster /dev/vdb /mnt   <== failure
> mount -t ocfs2 /dev/vdb /mnt && umount /mnt <== clean slot 0
> mount -t ocfs2 -o nocluster /dev/vdb /mnt   <== success
> 
> <6> simulate after crash status for nocluster env
> 
> (below all steps did on node1. node2 is unmount status)
> mount -t ocfs2 -o nocluster /dev/vdb /mnt
> dd if=/dev/vdb bs=1 count=8 skip=76058624 of=/root/slotmap.nocluster.mnted
> umount /mnt
> dd if=/root/slotmap.nocluster.mnted of=/dev/vdb seek=76058624 bs=1 count=8
> mount -t ocfs2 /dev/vdb /mnt   <== failure
> mount -t ocfs2 -o nocluster /dev/vdb /mnt && umount /mnt <== clean slot 0
> mount -t ocfs2 /dev/vdb /mnt   <== success
> 
'bs=1 count=8 skip=76058624', is this for slotmap backup?

Thanks,
Joseph

> 
> -----
> For test case <4>, the kernel job is done, but there still left
> userspace work todo. 
> In my view, mount.ocfs2 needs add double confirm for this scenario.
> 
> current style:
> ```
> # mount -t ocfs2 -o nocluster /dev/vdb /mnt && umount /mnt
> Warning: to mount a clustered volume without the cluster stack.
> Please make sure you only mount the file system from one node.
> Otherwise, the file system may be damaged.
> Proceed (y/N): y
> ```
> 
> I plan to change as:
> ```
> # mount -t ocfs2 -o nocluster /dev/vdb /mnt && umount /mnt
> Warning: to mount a clustered volume without the cluster stack.
> Please make sure you only mount the file system from one node.
> Otherwise, the file system may be damaged.
> Proceed (y/N): y
> Warning: detect volume already mounted as nocluster mode.
> Do you mount this volume on another node?
> Please confirm you want to mount this volume on this node.
> Proceed (y/N): y
> ```
> 
> Heming Zhao (1):
>   ocfs2: fix ocfs2_find_slot repeats alloc same slot issue
> 
>  fs/ocfs2/dlmglue.c  |  3 ++
>  fs/ocfs2/ocfs2_fs.h |  3 ++
>  fs/ocfs2/slot_map.c | 70 ++++++++++++++++++++++++++++++++++++---------
>  3 files changed, 62 insertions(+), 14 deletions(-)
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
