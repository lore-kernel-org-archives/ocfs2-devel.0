Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28E6EC433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Jun 2022 15:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hY5v+4ZWNTKFMziObu9S8mkTq9JePH3HBaY0t9mQzCE=;
 b=0r3Zrjx2UJyRVZsErLDkYq0IY9Hv0HEqONWR0NddGA7/TwwpF2mGwfcc1OfijmXiASyzVQJmKbE7
   ++0OUBQr7/4GbsHIRg8vekfWnQ6d84TZXpLjwOiXMtOEtmz3G8WUcU7AX2vd41QuYZQq1HWiICXL
   biXJkkdvTPLTIPRXJvEU2xPA1809cWluscF1JJPrQNEwl/9ucmGZMa6eOjNq0bY3cjd3YvVEYSrZ
   7Cu8LdyWQWCxeVNqPyLTlRmQxQEIenaMK8Qg/TAok7sSLEj3VKPnAeG3s0Avr7/of4mbIaPMPXpQ
   0a/NKgpRoJtThI6fymHpDi3EBuRMQz1U+MDelQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hY5v+4ZWNTKFMziObu9S8mkTq9JePH3HBaY0t9mQzCE=;
 b=n5yacvuYDlERHGPRv66B71QMwdrdzAcONirUlB8CoMnuCq/r2AUb4blrwnQZrygs2e6IlojK3PYY
   h4SS65shamck85cqY4Z3f9uRT0EEH4+SdpcoENd/f+sV+Inz23IvnPHv5zhW/RMH8gV99XHvsjNg
   u3BqWG9MVzwOW/cXANriUPMBp7Y4/ON1tl0dEU5zZtoITrzlFLLc29y8QLx+VQNtJIA4wSCfg6Vl
   uLlt8g9joWtipx3n7Vah3x4C3tSoPh5ao8RtxCFEumOQ8mUCfi2mEi9+pnav9B8NcYeA3H1G93f2
   jerTSdbmmjKSGqxeNJe1uLlKVVkhB6FVFtnBng==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD400MOM4HWDS60@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Jun 2022 15:03:32 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=4jzHTv5Sc0MldAT+k988WZMZ/PcoJBlwM2totgWZy1o=; b=kAmWthY2O8UluBnxjle5Z4b8CR
 wMBrQhwOGev5bLR4SD2g4KFCVqn0rNm7UKcacjYNHOp4Zi9DN4hFNNpg/rdYnkQ2Bitnt2jS/8yep
 J4RQx8E76Apo84LVth+zXy/EGiNNhGntaPmOyPt7MAf32pEy9j0ya4oCKAyveSeAvj+/Bahjw/WS5
 PkxrMT8th9jzoXK8Ozl9TZiDmysXQUNCSiVKvMvkBzEn1CjwgpXgRMlrbmn3RA54WDQPV+9+5Dfdw
 DH8s3QnSLteEcLhDUV0m22q0hL+gDPGr4PGZVl9no1Krcd/RbUTmqDuxBUlxLXzpM46q69eZL4xIc
 YyTs3kwg==;
Date: Tue, 7 Jun 2022 16:02:55 +0100
To: kernel test robot <lkp@intel.com>
Message-id: <Yp9on0GvbGbdN+cv@casper.infradead.org>
References: <20220606204050.2625949-15-willy@infradead.org>
 <202206071414.41wGG8fp-lkp@intel.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <202206071414.41wGG8fp-lkp@intel.com>
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=5 mlxlogscore=128
 suspectscore=0 bulkscore=0 phishscore=0 impostorscore=0 malwarescore=0
 priorityscore=162 adultscore=0 clxscore=178 mlxscore=5 spamscore=5
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206070061 domainage_hfrom=8379
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 kbuild-all@lists.01.org, linux-ntfs-dev@lists.sourceforge.net,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-block@vger.kernel.org, linux-mm@kvack.org,
 linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 14/20] hugetlb: Convert to migrate_folio
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
From: Matthew Wilcox via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Matthew Wilcox <willy@infradead.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: casper.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: _8k2gC_dSzsBZBARGLzZFGx8d9IPE7Dv
X-Proofpoint-ORIG-GUID: _8k2gC_dSzsBZBARGLzZFGx8d9IPE7Dv
Reporting-Meta:
 AAEyJHhYEUUd0xhzdB7fWyOiSokxx+Apf7roaaN/WrhzTeGGXGIQATTYGKHd3Chg
 V5Bx36cULNnq3J5hLQWa/aoPYrjlvgMziygPxLscT+IedaE4ljAxZh9InlRFb4iD
 BkUmE0khvDth31spfv/uD5EtmpHS8pjqSLjUP86gYVAjRw2NueNcc+gLsMU6Clng
 fV1tMa/WlcehDVM5weXKBYuz06D+sDswCtK5iMnHN2H2G0kTt4qHqaafzfSxZEYM
 v0ZlYbDQjjsPyFYO0bC8ppjZiAJ03FdzZ4e/BS0Xji1/hRO1rdM5DI+QExXpU/fq
 geBTWH3YIbnDEq+ubVTAC1rkhjEYYurmZMOzkB7uIWhn07XQypRp06Udm221oA6Y
 OPZr6LIRf3N1sEjjEwcfXBVoDnbGQT3S7xpE0AxlSKUuI2MELQCAQCUMcb9ZaAD7
 fxmH19PfyPoncasFG3V/bQJxhZUZdRF5EXZGOjpgIZ5wwePFe0q79wqz7m9sPvmA
 Xvxh4udbIfvY69f9GBbeQAezRqFmvkqYqAePEg8A7f4=

On Tue, Jun 07, 2022 at 02:13:26PM +0800, kernel test robot wrote:
>    fs/hugetlbfs/inode.c: In function 'hugetlbfs_migrate_folio':
> >> fs/hugetlbfs/inode.c:990:17: error: implicit declaration of function 'folio_migrate_copy' [-Werror=implicit-function-declaration]
>      990 |                 folio_migrate_copy(dst, src);
>          |                 ^~~~~~~~~~~~~~~~~~
> >> fs/hugetlbfs/inode.c:992:17: error: implicit declaration of function 'folio_migrate_flags'; did you mean 'folio_mapping_flags'? [-Werror=implicit-function-declaration]
>      992 |                 folio_migrate_flags(dst, src);
>          |                 ^~~~~~~~~~~~~~~~~~~
>          |                 folio_mapping_flags
>    cc1: some warnings being treated as errors

Thanks, fixed.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
