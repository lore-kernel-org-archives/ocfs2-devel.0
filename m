Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49AD0C43334
	for <ocfs2-devel@archiver.kernel.org>; Thu,  2 Jun 2022 10:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EwJwZI5F8NR2XVv3o6X3ZsPc8heJoYJ5ObjVXSPJvQE=;
 b=B3Xfwe5ZPiad6MrgSVPFDPCt+fp7FdxW4hkRb4vwtsum/KC8BGmC+4sPx7jVyNFBYSgAx3D8FIuF
   rv7oGQEalOlKLHGXmLw07An+Fph7MAGXWzTaA7ye154kJvORn8U6g2QdzNbUVkNwMTviE62epT04
   iSH3wciOH7lW9hxwIN7fdAJC0I+U9imKYMHeBIy3WPTNJT1immsmXfkfkdezyok9wdidbZsA8ZHq
   pTqUP89fKIWpqh2OZhZkmhuiYRFgcj0D4+vnZhXJCI8hFTI3vWS4FIXY6Ly19oTFJrCeJua0IJcw
   hOtznUg31EKKcGTx5u3RzKakaafe30YUvxNaBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EwJwZI5F8NR2XVv3o6X3ZsPc8heJoYJ5ObjVXSPJvQE=;
 b=I/+3yCkfXCmbGKVOSwUt7E7ojH4pqxEEZtKxDKGjK+sq6pMtvUess57ZJupydRfAWdaGgEFSUlDV
   J4ClCq2ppV1gHQZKjDVE24u5T5TDviCEbAqa8vC9sILsA7E65EbmXSkVzWS0E6CIcGO49zadqMLd
   uM+fE29pKZ5qfypzjG7z3UVB6lh0S/joB9zR5K5HH8+3pb3jq68MH4oia6dLLqc0OHa7Yp3zIiTA
   +egJt7h8t8dw6u67dD2DnICQaHS+Zy6MqQfeUfQJ2agBaSrsg+pWsd2btoNeehU7kSQL/bCaSlHk
   NP+YegfHlCtWtcWcJpTf+8YsDBfoJNeLE1X0ww==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RCU00H82H8DTY90@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 02 Jun 2022 10:02:37 +0000 (GMT)
Message-id: <8c001d9a-ffa0-7173-1429-de19bd4779a5@linux.alibaba.com>
Date: Thu, 2 Jun 2022 18:02:19 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220521101416.29793-1-heming.zhao@suse.com>
 <20220521101416.29793-2-heming.zhao@suse.com>
In-reply-to: <20220521101416.29793-2-heming.zhao@suse.com>
X-Source-IP: 115.124.30.45
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10365
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 phishscore=0 clxscore=92 mlxlogscore=864 suspectscore=0 malwarescore=0
 spamscore=0 priorityscore=60 lowpriorityscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206020042 domainage_hfrom=8449
Subject: Re: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix for local alloc window
 restore unconditionally
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R811e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VFAAXci_1654164140;
X-ServerName: out30-45.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 89kNIUxtpf61h9KOhreThVNUwz-s0gmc
X-Proofpoint-GUID: 89kNIUxtpf61h9KOhreThVNUwz-s0gmc
Reporting-Meta:
 AAEybvSUAmG8fT7L175ZWQfjNtLOhqZVQk/DZeHEwxR55HiOxart3PJg/oLM9q63
 pQsgpL5mw9qBdMtlnZW7x5+HsEmJRE4/vqTLXcNdG00XHq9BepDWnDtip+z8YCYB
 yaKiWxMNzFm30tMcOOfESHItPtW9mgo3L29i0I0j5psG2vIS7xePNsNNUsqJuMM9
 qaHW6Hk0sB1m6m8owMd8mAGFXtN2j1nLO7IZk5qs0wypG6YRz3erM4LwoCwdVFPP
 C83qpfVJ46ck1Vn2soafMATyDoo7NUfID1HgX/vypuGLaVO4f3MXtTd4SSkO8P/a
 2r2YBi96a8vvbjeyfcOfx5WcsTtOSWJPLRrQGIdS+Z2xc6PmQfemCuusVMwBosra
 nkSCx6001n8tUTs0/TV5sC9JRhSs0ZR4TIX7fhZVt2qwpr34M9m1xfRbXAl+t+q0
 CTCw/wD2VDqW53GBLVaQ2XqhTJ75D6baX02chuQasIPUD5+qQEXsaCvnsLFFxwU9
 pzMtZdhkuB/3DXdo0yDm6MjNJm9Nu8plsSS/HUVUaHg=



On 5/21/22 6:14 PM, Heming Zhao wrote:
> When la state is ENABLE, ocfs2_recalc_la_window restores la window
> unconditionally. The logic is wrong.
> 
> Let's image below path.
> 
> 1. la state (->local_alloc_state) is set THROTTLED or DISABLED.
> 
> 2. About 30s (OCFS2_LA_ENABLE_INTERVAL), delayed work is triggered,
>    ocfs2_la_enable_worker set la state to ENABLED directly.
> 
> 3. a write IOs thread run:
> 
>    ```
>    ocfs2_write_begin
>     ...
>      ocfs2_lock_allocators
>       ocfs2_reserve_clusters
>        ocfs2_reserve_clusters_with_limit
>         ocfs2_reserve_local_alloc_bits
>          ocfs2_local_alloc_slide_window // [1]
>           + ocfs2_recalc_la_window(osb, OCFS2_LA_EVENT_SLIDE) // [2]
>           + ...
>           + ocfs2_local_alloc_new_window
>              ocfs2_claim_clusters // [3]
>    ```
> 
> [1]: will be called when la window bits used up.
> [2]: under la state is ENABLED (eg OCFS2_LA_ENABLE_INTERVAL delayed work
>      happened), it unconditionally restores la window to default value.
> [3]: will use default la window size to search clusters. IMO the timing
>      is O(n^4). The timing O(n^4) will cost huge time to scan global
>      bitmap. It makes write IOs (eg user space 'dd') become dramatically
>      slow.
> 
> i.e.
> an ocfs2 partition size: 1.45TB, cluster size: 4KB,
> la window default size: 106MB.
> The partition is fragmentation by creating & deleting huge mount of
> small file.
> 
> the timing should be (the number got from real world):
> - la window size change order (size: MB):
>   106, 53, 26.5, 13, 6.5, 3.25, 1.6, 0.8
>   only 0.8MB succeed, 0.8MB also triggers la window to disable.
>   ocfs2_local_alloc_new_window retries 8 times, first 7 times totally
>   runs in worst case.
> - group chain number: 242
>   ocfs2_claim_suballoc_bits calls for-loop 242 times
> - each chain has 49 block group
>   ocfs2_search_chain calls while-loop 49 times
> - each bg has 32256 blocks
>   ocfs2_block_group_find_clear_bits calls while-loop for 32256 bits.
>   for ocfs2_find_next_zero_bit uses ffz() to find zero bit, let's use
>   (32256/64) for timing calucation.
> 
> So the loop times: 7*242*49*(32256/64) = 41835024 (~42 million times)
> 
> In the worst case, user space writes 100MB data will trigger 42M scanning
> times, and if the write can't finish within 30s (OCFS2_LA_ENABLE_INTERVAL),
> the write IO will suffer another 42M scanning times. It makes the ocfs2
> partition keep pool performance all the time.
> 

The scenario makes sense.
I have to spend more time to dig into the code and then get back to you.

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
