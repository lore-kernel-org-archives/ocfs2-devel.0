Return-Path: <SRS0=eIKw=IB=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C6BAC433DB
	for <ocfs2-devel@archiver.kernel.org>; Wed,  3 Mar 2021 09:45:10 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C216B64EF0
	for <ocfs2-devel@archiver.kernel.org>; Wed,  3 Mar 2021 09:45:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C216B64EF0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1239iMku113472;
	Wed, 3 Mar 2021 09:45:08 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 3726v787gh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Mar 2021 09:45:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1239ibM8101311;
	Wed, 3 Mar 2021 09:45:07 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36yyut7hy1-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 03 Mar 2021 09:45:07 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lHO41-0007sn-JD; Wed, 03 Mar 2021 01:45:05 -0800
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63) (envelope-from <hch@lst.de>)
	id 1lHO40-0007sY-4U
	for ocfs2-devel@oss.oracle.com; Wed, 03 Mar 2021 01:45:04 -0800
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1239j3Lm193696
	for <ocfs2-devel@oss.oracle.com>; Wed, 3 Mar 2021 09:45:03 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3030.oracle.com with ESMTP id 37000y72kv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 03 Mar 2021 09:45:03 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1239hR4E002080
	for <ocfs2-devel@oss.oracle.com>; Wed, 3 Mar 2021 09:44:58 GMT
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by userp2040.oracle.com with ESMTP id 36ycpvk631-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 03 Mar 2021 09:44:58 +0000
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4F89968CFE; Wed,  3 Mar 2021 10:44:54 +0100 (CET)
Date: Wed, 3 Mar 2021 10:44:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
Message-ID: <20210303094454.GA15967@lst.de>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<OSBPR01MB2920FB5AD1C9ADC64100238AF4989@OSBPR01MB2920.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <OSBPR01MB2920FB5AD1C9ADC64100238AF4989@OSBPR01MB2920.jpnprd01.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-PDR: PASS
X-Source-IP: 213.95.11.211
X-ServerName: verein.lst.de
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9911
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
	priorityscore=0
	lowpriorityscore=0 malwarescore=0 mlxscore=0 impostorscore=0
	phishscore=0
	bulkscore=0 clxscore=184 mlxlogscore=840 suspectscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103030073
X-Spam: Clean
Cc: "jack@suse.cz" <jack@suse.cz>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [Ocfs2-devel] [PATCH v2 05/10] fsdax: Replace mmap entry in
	case of CoW
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9911 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103030073
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9911 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0 mlxscore=0
 suspectscore=0 adultscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 clxscore=1034
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103030073

On Wed, Mar 03, 2021 at 09:41:54AM +0000, ruansy.fnst@fujitsu.com wrote:
> 
> > >
> > >       if (dirty)
> > >               __mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> > 
> > I still think the __mark_inode_dirty should just be moved into the one
> > caller that needs it.
> 
> I found that the dirty flag will be used in the next few lines, so I keep
> this function inside. If I move it outside, the drity flag should be passed
> in as well. 
> 
> @@ -774,6 +780,9 @@ static void *dax_insert_entry(struct xa_state *xas,
>          if (dirty)
>                  xas_set_mark(xas, PAGECACHE_TAG_DIRTY);
>  
> +       if (cow)
> +               xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);
> +
>          xas_unlock_irq(xas);
>          return entry;
> }
> 
> 
> So, may I ask what's your purpose for doing in that way?

Oh, true.  We can't just move that out as the xas needs to stay
locked.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
