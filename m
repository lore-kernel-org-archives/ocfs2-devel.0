Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F4B2EB64D7
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 05:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=dKC56j5KpfjV58wIkgE4zrl+60ci580EjuyERXzHc5I=;
 b=ifDCzc53W8aEwRQuLK0amB4bTb5olzUfz77AgJo53vJu/ipM3lg0xpjpBfdWAQRMUZTtUfwi7+3w
   fwnLxTCrHwAQ6GivHSt/FRJpSrVx3yPqBHQ5wJLXC8OMvqVWAgqVyFZt7lcvrjEPoF5MsA9cM7Nw
   +n4JJGFWn/pR60MtzfTA8kXjiR5pENYmakkCx/olXjNzwsxXSGtc+FQDJMxwEtmW4d/YCjovTLVy
   RnMtodeK68WrpVuDaQD/MlKHbEdr0pyWz/bujFtAo8u4+EKNwT94eYkbseiiJWuSLql2gqjkM1Sv
   wh6yTZIb2RWz51SmtOLK9U/VvokCjzUErY6SEw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=dKC56j5KpfjV58wIkgE4zrl+60ci580EjuyERXzHc5I=;
 b=fXIi4ZR50MX16Ddy3fBOhzeoWBxo+WDIPsBlnm9+e3E0eNftprP3PsDRYDsp8JzjNzmDyfi8ba4Z
   yoRskV59ZIvT3veb1QDQRJC3d6+kX30TVzYcJYOqwEKzeSl/6NNFQcntQDO4wGBPJYF13Z0tQq7g
   PSxf5pueqRnSftHBPRwkTXVyosznvdXZxtIcWU7i1ic3jVshNXEQnrIpx+M46Z/ZzPhwDTkrGU9f
   cNglLQALRxoD3raFTyIGR+UbseV3gAMmnY/iOc2mXxBkUPSkeyr4ioi/F+iQ4MLWXt/yXKKya7wf
   rtOSTkJuu4/KAHhgWGJLRZTOmzyVbmDfA+N/vw==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWJ00JZKE5AHJC0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 05:34:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=tv/KxUiDyInx1PDIV4kKpPvm49qY+WbJYdAJ6sLDhoI=; b=R/t46TzhdTxke4UZWex1PeqvLr
 IRfKCDDZTIim72lwJr8JnaG7z7w7yqd4Q3ncT9V6yosKeD8/lu7DDIHSW8OL3CzY79OHW7H4shFFR
 HBy2XN3Tcx1JqfgZzSthwJGEKqDEdvxCOmRJ5qxKXNmxU9Up20N32mjZUcgGKmf1I3ORDTAxoequ3
 UYP8qjGwFBHujcKbmWuPWmmPzmbHN3K8/IvlialHYgfWAikGSoNh2o7pby7XzpUv/rE9pP2IVR8sB
 0DzWdX/8NwU4WW/g+MMRofhK4dQ2jPuNL4tnXylJUipBM81fPkPkUlbRlQD71cETnHVAdCf3AvFdr
 JaGyFSIg==;
Date: Tue, 20 Jun 2023 06:33:41 +0100
To: Bean Huo <beanhuo@iokpp.de>
Message-id: <ZJE6Nf6XmeHIlFJI@casper.infradead.org>
References: <20230619211827.707054-1-beanhuo@iokpp.de>
 <20230619211827.707054-2-beanhuo@iokpp.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230619211827.707054-2-beanhuo@iokpp.de>
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10746
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=283
 mlxlogscore=729 phishscore=0 priorityscore=162 adultscore=0 impostorscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306200049 domainage_hfrom=8757
Cc: brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 beanhuo@micron.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
 jack@suse.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 1/5] fs/buffer: clean up	block_commit_write
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
X-Proofpoint-GUID: RqhxSCLNL91EcGHXBJms6--ZiehePpAv
X-Proofpoint-ORIG-GUID: RqhxSCLNL91EcGHXBJms6--ZiehePpAv
Reporting-Meta:
 AAHAtckAKFi1UxcRjLIJBvtI9yXX2DEYEQ8aAG/WoXG6qJbuYAXwL/Lb+twLNtON
 7rbh37hFE+lKFzvq6RRzjOzK1ToOKZDEuJiIM5nAjIIw0oHsJdKv/+/XzRVlHJAe
 yMUZCJFm3QINH2dLiAk20IdwoMsjoLN76J6Ul0LNQGvt007i+0E93Xlo3eNzXcUW
 uBpBZjxbWaZAFM+vhtkyKY5CWfstsiPmfSPxyU7Iq7wFST8petwPF/W9T+q03Kgl
 hxRS66bxIoYwjlfA0MV3zYSW4O1zut/MRVyJwpaM1VuK+WHufUeP4S9CGUaqMvLb
 c4QfRnF3vJyRB9Alep9zpmS0kIcCKBNNhPtwYrmYkVQcd+Rd7/oeE1BeilXD84/L
 4ebHV6dYLXpdYu8O+Irf2td8ZPFvX1PIamSGyCXTonl5B3VhJCVCdzsfBGBhLMSf
 i8ZDBAE1aT8fIsuIlv7EbmsL7ab9OBqQ7ZTAvkHouABMB/pHvvTcDnccdnaacAp7
 BHV9BP7cGCoT9LDbgIgyuj/TN5FJd/jqf92CdpjfwCY=

On Mon, Jun 19, 2023 at 11:18:23PM +0200, Bean Huo wrote:
> +++ b/fs/buffer.c
> @@ -2116,8 +2116,7 @@ int __block_write_begin(struct page *page, loff_t pos, unsigned len,
>  }
>  EXPORT_SYMBOL(__block_write_begin);
>  
> -static int __block_commit_write(struct inode *inode, struct page *page,
> -		unsigned from, unsigned to)
> +int block_commit_write(struct page *page, unsigned int from, unsigned int to)
>  {
>  	unsigned block_start, block_end;
>  	int partial = 0;

You're going to need to redo these patches, I'm afraid.  A series of
patches I wrote just went in that convert __block_commit_write (but
not block_commit_write) to take a folio instead of a page.


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
