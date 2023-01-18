Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F6EBC32793
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 Jan 2023 21:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cZKRP/eD6dgzcVinVIYzdYtblXdAdCmGS+zL3x1dLXI=;
 b=DesQDtuIULaAT3VH69FNQ6cTiWwSMgT+8gpMTXiwyy5SHXsV9KL32DK95ITB9Y+j5fduDATWQY15
   3fyg+vVTe6OH/yFoasXYrolqQWnMxgLPLvTFhsH17SHP4Qj3iGqsCalOeov2WtOW0jElQ11xemjF
   9gH/l34UVX8oDgc8XE3jhSHikVPghrn1s4H3jg9wCc+b4UdSqetVGkh88D6LwzMX5TMbxhZOvKf/
   S/v5tRzxH4vW+EKQnLFqOJ1bur+JT3usm4fRZSnxmmyXhlNMPb/bnFuwi13n4cY/Cwadd/SCg2b7
   Q6ZcbDDjYf69+4UY1DClTtnl+TswV/6VV/QEtQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cZKRP/eD6dgzcVinVIYzdYtblXdAdCmGS+zL3x1dLXI=;
 b=nByyKxScF0kT9IU+2PCLo93b8j1OPvfjM5s0xACS1YW7BgfdAYAjbSCpmvQuzKWCUS8NoVMgWabB
   yjR76QzZ/Kr9fjQF0b9131PlK9p3Ad+zifMbwuvmmTGuG4z22xLQP+4JMTfCpfMn+oOLy1E0JLqL
   /sIGtyczxZAEjOnGiY/beu6jpCWKDWh6DB9aEqgqC6IaX7qTw+v9qMBmuOh/utCS2CIs0vsJIcgO
   kLQQJY4RG/scsSH+2b8IdqjUHess7Kif1i2qD3LA7gOeNpCE2k5T09FG++KJTz1LoCwjoACbL1Eq
   7cQo2h/rOrCw3rCGiqmRo4aD4JqVfJt8j++pSA==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROP00BIEA487PD0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 18 Jan 2023 21:24:08 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=n+mw9lCCjk5X3T9xtDdQJN9vPxX3IIIv9RMOBrZipMA=; b=cAcwD9Cv2X/HLr205M+1qJdJXE
 pnbobwarCEbw82zWge6795tasauPOC6nTrME3SDL8CrYud98PgtHcXfwYjC30jJ1OF/7tkVM58L+o
 PPMTE8G72UtPDBmZOTH2LCB/ibZ9Ls1TDsCdUdFXP3USV2XyZNaW2HrqDU/RVEOC12LmPb7xQFNee
 eY3j+DoyNoeMk85olgLjZcosXq8a29WdbK7adbqgN5s6R3ffw5vwaqnU/CIYV5d9Z6DpgjK/ECkha
 IggWE5LpZD1SCEGA9mKPEXo7qgsyibWXcEE4kFBOUMY+L+b8WKIS8OOlRiH6qiG+Ga1Auxt3cXR5W
 s8CKCskQ==;
Date: Wed, 18 Jan 2023 21:23:37 +0000
To: Christoph Hellwig <hch@lst.de>
Message-id: <Y8hjWSfC8TVCx5Fe@ZenIV>
References: <20230118173027.294869-1-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230118173027.294869-1-hch@lst.de>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10594
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=60 lowpriorityscore=0
 mlxlogscore=709 mlxscore=0 impostorscore=0 spamscore=0 suspectscore=0
 clxscore=120 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180180
Cc: Evgeniy Dushistov <dushistov@mail.ru>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] remove most callers of write_one_page v3
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
From: Al Viro via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Al Viro <viro@zeniv.linux.org.uk>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: zeniv.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: LBjnLHycsQ5F6HeGOo7OVEq8CHXmGgZj
X-Proofpoint-ORIG-GUID: LBjnLHycsQ5F6HeGOo7OVEq8CHXmGgZj
Reporting-Meta:
 AAEmzazuJ5vIZ39fKA57LsOJs2g4QXC4RaRd+sN/xPff4/ty5Hkctb4eHJz0DF19
 ZCfkIDyWxBOHIw0rKfwb9LGJfjNbg9O9yhFw2hitZqXBa91BWiH8RbpIAhOT3WiG
 AFDbtzTMxNNNyrv0OufZ6xom9pD1UbFdACvv9w2KUtccmWMv72UAO5ns031ZKit8
 oAcWnIBGIMadzMW5bqWztuw/rNqjSkD5ihsz8uVzvNkvYY4KUgxvaKtXj44vX97L
 /wRH3p1tVBvnwF508FvJRx7Zgys9dTU0oNqXYezuQ7gc1Mcqtx39lM0T8jhnJOWX
 q6648pkjMl9/U+NgrUIGXdk3Uu2z6+mk65nrLCR04/Hwxw6JBgbn7ARyDsB1RCrs
 9A6kMaFHyblvLtIUBZy/9SYES09f3+3Y86RZJdlLOM+Gwz43TzoMwRUP3tkbhIoU
 rQQ1QPYIbb/t8NRy/3u91D6ZiqBpV4xB7uzhokFDRUJAWrQRzKOOKzMAkktTlIs6
 R9Z54z97JYv2y50rF9LJz4ty2qiMTxFu//FLRC00ZLQ=

On Wed, Jan 18, 2023 at 06:30:20PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series removes most users of the write_one_page API.  These helpers
> internally call ->writepage which we are gradually removing from the
> kernel.
> 
> Changes since v2:
>  - more minix error handling fixes
> 
> Changes since v1:
>  - drop the btrfs changes (queue up in the btrfs tree)
>  - drop the finaly move to jfs (can't be done without the btrfs patches)
>  - fix the existing minix code to properly propagate errors

Grabbed.  I'll split that into per-fs branches (and synchronize wrt
fixes), fold the kmap_local stuff into that and push out.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
