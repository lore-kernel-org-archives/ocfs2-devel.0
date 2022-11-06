Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D1AC4332F
	for <ocfs2-devel@archiver.kernel.org>; Sun,  6 Nov 2022 12:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nBvfFf6xfo+PIqUtJb9bxJBsWIJliDreMKo/U7xoQ4c=;
 b=NonZ34ax/hNtxvW4CMK2uIOlk2bMgoXTWd6r9c+v7qKJLIvO1qJIt6njccfzqBT8UvVHrBtNJDZb
   YPPZTP9Ooof/PalGY7cFQCgLDjq5neyuHttGgzeIACApiovi/l5FStob6Ym8Iz+THssaRxuQo+ho
   edPiNR2Izbg4j8/6KfClpV08zAa543GyJdskB9Ii4YueRdB+M1Q8Q28QAXzCKedgPubMlXVBY9Pj
   gHtjst8SaQPBhqiMAKSHoEiyfLfuF6RUaWS69QGeOKylBeWtwwWO+DMssm/ve3wX1NDsXrridqXt
   X2gdChWcjznpROFsm36Lxm7yGprgulliXYwvYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nBvfFf6xfo+PIqUtJb9bxJBsWIJliDreMKo/U7xoQ4c=;
 b=Cv20r3k7FP5q1dQNQG7BfoF+PON6KUFOR7kNCkJmnDROt2DX68W+htH3VsHT0OvsdmD+sXwaQvNY
   S5Zyy5GtJ7OSDjJhQd97D816K5F5+FMrqSKj6BxOwRiDWifrjwTRYgdN7Wedowwk6vgx0GKBO0HM
   TpbnUzm9IFKElI7YdHdE04++R9BjLfgjKQa4bd/wqO0lB3khG9jBuGaHwMMWIPm2K86MzfP/iO7d
   Z0Zh2vrT331Q/tW16RgypDyCLV1DZomhutA9A4hf87R8RM6obGh9g7EJ3y1GDtErkhvRXT9Sk0zj
   DSxi3LVJSbUIKTyi6zNnuVTr8sRrDUpXUpzWyQ==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221026 64bit (built Oct 26
 2022))
 with ESMTPS id <0RKX009ZIF42IB20@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 06 Nov 2022 12:38:26 +0000 (GMT)
Message-id: <97361840-0a56-f074-0495-712dafe4313d@linux.alibaba.com>
Date: Sun, 6 Nov 2022 20:38:07 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
To: Dan Carpenter <error27@gmail.com>, oe-kbuild@lists.linux.dev,
 Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
References: <202211050722.8YGvtPaR-lkp@intel.com>
Content-language: en-US
In-reply-to: <202211050722.8YGvtPaR-lkp@intel.com>
X-Source-IP: 115.124.30.43
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10522
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=92
 adultscore=0 bulkscore=0 spamscore=0 impostorscore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 priorityscore=70 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211060115 domainage_hfrom=8606
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 linux-kernel@vger.kernel.org, lkp@intel.com, oe-kbuild-all@lists.linux.dev
Subject: Re: [Ocfs2-devel] fs/ocfs2/super.c:1809 ocfs2_mount_volume() warn:
 missing error code 'status'
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R161e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046059;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
 TI=SMTPD_---0VU3D5cg_1667738288;
X-ServerName: out30-43.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: vAA1px1T82DSoWisLQOK-3jr2sHLoQBk
X-Proofpoint-GUID: vAA1px1T82DSoWisLQOK-3jr2sHLoQBk
Reporting-Meta:
 AAGdce57fNZlM9oTW/gUlP3943szkLXfFsOqprbj8114urAehw4r7xbPU+RkyC4K
 Icl0LKLGG7SFTTsEqg/WEY51yP7ILdGm08UdJvoBv16pRvsNkkaOXcrh3lpf6bKE
 bkhi05+ErtTz94zDLDKclZcnSgyWyk/FhUBi7Yp7VfAcmZWUllBQ9/KuKjjIpIU3
 rWkbeu1hmC1BNqpehMiiZglOhkf717rtobed/skPl2I1bY7u8HZ84P22xCr8zwtg
 s3q6GzAjwAIVtLgfGUfgboIXAvee+QQxA4xUbyNn5KcWh41hnEsmnzf361qGipMf
 s8YtSpnLwu3WtcVJ1NCr6Z30yFsS3UZaeFrCzLAB79N0dRP701ckCR2jPPOFLoYc
 mAu7SMD9RkMMMpS1m6z7f/Bz/O3zO/LHdlbue3TE/v8y+I4vvTk4lXruDpCkIUBL
 19oq5K2AR2EeTMlxM6BaIXanCeBSTCyHS4axc8bfPAke/OyVy3A3VEA8Us6bSC63
 FA3eY14+UAtTHYO0LJVlVABsWtJKobbYthQFSEvFDGQ=



On 11/5/22 7:15 PM, Dan Carpenter wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   10d916c86ecafeccaed89175ebf9b832dddde380
> commit: 0737e01de9c411e4db87dcedf4a9789d41b1c5c1 ocfs2: ocfs2_mount_volume does cleanup job before return error
> config: alpha-randconfig-m041-20221030
> compiler: alpha-linux-gcc (GCC) 12.1.0
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <error27@gmail.com>
> 
> smatch warnings:
> fs/ocfs2/super.c:1809 ocfs2_mount_volume() warn: missing error code 'status'
> 
> vim +/status +1809 fs/ocfs2/super.c
> 
> ccd979bdbce9fba Mark Fasheh                 2005-12-15  1802  
> ccd979bdbce9fba Mark Fasheh                 2005-12-15  1803  static int ocfs2_mount_volume(struct super_block *sb)
> ccd979bdbce9fba Mark Fasheh                 2005-12-15  1804  {
> ccd979bdbce9fba Mark Fasheh                 2005-12-15  1805  	int status = 0;
> ccd979bdbce9fba Mark Fasheh                 2005-12-15  1806  	struct ocfs2_super *osb = OCFS2_SB(sb);
> ccd979bdbce9fba Mark Fasheh                 2005-12-15  1807  
> ccd979bdbce9fba Mark Fasheh                 2005-12-15  1808  	if (ocfs2_is_hard_readonly(osb))
> 0737e01de9c411e Heming Zhao via Ocfs2-devel 2022-04-29 @1809  		goto out;
> 
> Unclear if this is an error path or a success path.  Honestly, I would
> have thought the checker is correct that it looks like a failure path.
> 
This indicates a readonly mount and bypasses dlm related initialization.
So it seems an expected success return.

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
