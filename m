Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9049C46467
	for <ocfs2-devel@archiver.kernel.org>; Mon,  2 Jan 2023 12:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=R1IHOjnBtYDaTReGKfikMgC0F/5OVJDPt6VsI6pO6ug=;
 b=GDDXxlFxZrY4fJdNnFc9p1tV/h3VWomGz1SF8ryblui65ddrYxeWNnEARnTOkEd/p5VYu6py+QMk
   6/RUNHr56LTT3JPkmBUGIIUqHZRd+tQo6dEoC9k+AVK1yp+cdNeGd1f4+BKPGdX545+WeVgJIWfo
   LwzFOzNL6h5mgNAlQEwv7b5hzGEQwY9ofQrjZMP/W89MWUbZUt3zp/nKNKbgKoHA87W8JVig5+E7
   UAjxYFVvn7XatCB0AhgIb8ByP0MD7xctyzKtVi3fNkVAhwzy+tyUuj3W7vhhS946pjEgdeCpzDjH
   mvNdPR/KL7HEpQAWV2flKtfv3QE+lpKYqsGiCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=R1IHOjnBtYDaTReGKfikMgC0F/5OVJDPt6VsI6pO6ug=;
 b=PBUs2wLSRXKRMCw8t9P/QmirEKf/EKujFuGEuj95yqGXiWBTQ2dIjWuBjTX2x2ID0AZPHJQd30+Z
   AxYA01MQ7fU5xOdiZEDKH1LMt/UV5w7V72Px8FwPrqaHk5WtA/H6gyruvaayRT3Xt8eNFkf4OMOa
   ieWjw4vdRYtITqqxcpvY+DKV0HRC2k2s/5+A4uGOvbI8YRYfTCrp0Cd51fqYt7qGmemB5o9sRqhQ
   ujSMTFaxk+Mwo+xbYDpWraJVO31OxDm68AsGyfp5rvZj82eVP87Lg+7tD9FbllH+Teh5etv59WU0
   wEF6/xZJud5c3cgbJARw35XUXxBKoRhctz+M+Q==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RNU004FVY2VFB90@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 02 Jan 2023 12:16:07 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1672661749;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=7p+1CYr35IMfZeXzMv9mW+b7Hyipf7RXjCQLefUwxuA=;
 b=Vdfb5kx7HXP1I4jfRVpYYRPbixX/OUrc798QzUyANCeCVUgrahv/iTI/auD/sNIdXdZSKb
 iI9TexVwDI77ARJL7kqzT3x7diyi2vgNz2rlIqnwPLKMMvZYqRyaCIEGL08IbqgzEk/L08
 dTV7Fs4vSHI6NTBRRthFFsD9cE38F7c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1672661749;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=7p+1CYr35IMfZeXzMv9mW+b7Hyipf7RXjCQLefUwxuA=;
 b=1syY9TgPoXIKMrutE+opNx6jC7wdgkUilzJMOgw1RjxHqG/Pa1+Zaf2Sg595NbauTyu4SI
 CB/VK0K3JpeupHAA==
Date: Mon, 2 Jan 2023 13:15:46 +0100
To: Christoph Hellwig <hch@lst.de>
Message-id: <20230102121546.fqpy55koaavfazm3@quack3>
References: <20221229161031.391878-1-hch@lst.de>
 <20221229161031.391878-6-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20221229161031.391878-6-hch@lst.de>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10577
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=149
 bulkscore=0 priorityscore=126 mlxlogscore=422 spamscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301020111
Cc: ntfs3@lists.linux.dev, Theodore Ts'o <tytso@mit.edu>, linux-mm@kvack.org,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 5/6] ocfs2: use filemap_fdatawrite_wbc
 instead of generic_writepages
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
From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Jan Kara <jack@suse.cz>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out1.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-GUID: NLXXvza4yD8j8Zsdg9fGYSakWlmhoTrk
X-Proofpoint-ORIG-GUID: NLXXvza4yD8j8Zsdg9fGYSakWlmhoTrk
Reporting-Meta:
 AAHI7mpuKxi2mVUawctrlMh286+DhRg6K+3bbeCIMp/mm47l4RQ1cLwOgnWFyZG7
 99862RguBmcy52wRbTlmcktAKD8d3jXh6rz49yfQJL2yKFC7RmZzeggIpO37diPX
 xeeYzmrvdC5SJ5NZqVxbowjhwxX3Ilwtx6Bc9Ejn07aYP2vurMxYxCDCkP00mOZ7
 5dkreGgl5/0aZofXyQEnpmqhY0Dm/yg7r+GgNlrA2C326F6nskIYZwTC63POb8Mu
 0Jf/+XLJ8zcKRBEOI/HWCP/RpLQRjWfiKlXpXlh4KJO/slbcRsS2zW7RnExD5O1H
 2Wpanm5/K9gDQ55hZiB5S4S2NXZJq0o2ZzXmME0R7sWZa241n/vdXx4/K58DAYht
 AnIbOimduHlQNdwzRNRGSfA122nJcHyN8QqZKZoZAJAEwMn8LRVRMTj6bu1XxdEi
 VHcf7VW+faQcFUWdxwJYh+x16fs87QfyTMTJI92nuJdOASuXPvLleeo9p6OVJYzn
 NonjveRu6i/1d6iFkzBao8EJSrk2E+eHgi9pR0L4+g==

On Thu 29-12-22 06:10:30, Christoph Hellwig wrote:
> filemap_fdatawrite_wbc is a fairly thing wrapper around do_writepages,
> and the big difference there is support for cgroup writeback, which
> is not supported by ocfs2, and the potential to use ->writepages instead
> of ->writepage, which ocfs2 does not currently implement but eventually
> should.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ocfs2/journal.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 59f612684c5178..25d8072ccfce46 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -852,7 +852,7 @@ static int ocfs2_journal_submit_inode_data_buffers(struct jbd2_inode *jinode)
>  		.range_end = jinode->i_dirty_end,
>  	};
>  
> -	return generic_writepages(mapping, &wbc);
> +	return filemap_fdatawrite_wbc(mapping, &wbc);
>  }
>  
>  int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
> -- 
> 2.35.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
