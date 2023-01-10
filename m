Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58AE4C5479D
	for <ocfs2-devel@archiver.kernel.org>; Tue, 10 Jan 2023 03:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MRoPndcW+2DR0b7Gp6d2OuCt3DyxUn+N+hLNRpwrTxw=;
 b=t+DHwvlMXiNGT/8E4P7g1o9qfIt/fdNnhdKlNyd1TjKC7g9NVW3tWIlGo9lVotJ5hLotYC01ZrH6
   ZDIc/JG+72fFGjEjL1qsI+wBwpyqIlAM0FIsnurnaZz/JtXP+uwJPD4d/t/4Eybv8UtHgXUzfwuB
   h/rS/F4VHH7FPiS0UrO5ryKEvN93iA1gLrW5ADowcio6/lsMzLt8PiHVvWn4bwreoY1hSb3N3SwS
   5/D6Fr7C5vQZ7CvtV08uywM0Qe/2VyS5oou3NQmCRYkBwoL41t/PvsdQVZp9iWbEg6uaPdv7Mfx5
   gToM7w77lguJriScmG/nxP7uL8R1HfiMUNEH5w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MRoPndcW+2DR0b7Gp6d2OuCt3DyxUn+N+hLNRpwrTxw=;
 b=npveT5azjPjLJ4pdF3TC58lkO3GROCw7k1vlZuEFk9/f/T3Rw0WbYLWOjSfXwkQJJYhGkUUBSSdA
   5Fj3ogRfghl5t+/n1K9/GG7KMvAjQYXS9/FXOjqTBQ8Kle+hGVlpLKrBHXmZwwX0d02vAJ3hkX/h
   Zqds80igYA0ahYfVmgMrfo3S2t5efek0sqKX4l3Ew0oN4LyOMYRL50Wl5mL7m8DJ6EJFv19NjdiL
   Bt1QfO/4020swTdB/iAO3cmNqX950uybgGec3/+Hzx28uzt3YGxY3tRzhfEwAXLjsgEHmc2ZxtoL
   2rkm4YR80XBMUuxUrHNSpKg4e7GL4huoS20jZA==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RO9000RS1UFHDA0@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 10 Jan 2023 03:03:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=Ie+rQH3mw2D5QoODuQ+CCdhtheNQpe0s3cmjyE1gSeQ=;
 b=hMJOr7gxNfRVXvptQWjnS8gggJmoU39dG01sMuSVgD+06ybLXZxq90y4dy3c96NbGF
 4ZT28Zq5UNherNLr00lPvH90N3EtrGwKCZ5w+s+Nk7G+2SJ6ZKT+sq5tu3EE3ULu3Kzw
 Tm1vipafgC4nL3i2C3ESwkGPiXyNWjk+DYNU5oYqzgFvUp2yw2WsLbuNqo2V0DWUVU/R
 4Q3HdEc6KdveDXPof/4iD/sv+HhtzWh5llcfA936NmkiAVO0yiQADoU9L8RAKYAkCMXx
 OowkMMJOMwmhX7BhL3tGmOP0dsjKWzhGNwVwtSMWuQP00OtD1lRZF8xUGLuC3jp0h/rG Im3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=Ie+rQH3mw2D5QoODuQ+CCdhtheNQpe0s3cmjyE1gSeQ=;
 b=sgzeB+gSVWhN/kPv+y2ofM27R7cZF9GVQmGBczdaWJ1rmlH7sf/LfamTLFC/g3LXxG
 t6NdJEP2T1JppfX2o0T3ETvSBzRQK5a/MKyhmHAMRF0De5v5tAH2HWyyXeIXWY/WcxYT
 52ZSXr/LUJXjTTBIi7EFFfeEu+5Xk41Ox+muD+vdzC6kDrdYPDlRLq9qy9XOEmbIo3zl
 cSl/dFBlr1OlNmVkzxp9hsBYcJJguupjF1IvvyhKuBNWIThoP9zvBZgVUF48l6RCz1zz
 bOArdUPaudymixP68mhw/u7G+UYNmhAAqC/6KVYzFOxalOpucRRgw5KojMKikR+2hWRg 8LFQ==
X-Gm-Message-State: AFqh2kpio/16LpDRRfoE3isaizouwJsYJP60+nZi0eVDv/tHEfqOEybj
 QGGtBhP087IztvbtP31JGEA=
X-Received: by 2002:a05:6a00:2281:b0:581:a8dc:8f95 with SMTP id
 f1-20020a056a00228100b00581a8dc8f95mr53203339pfe.12.1673319816855; Mon,
 09 Jan 2023 19:03:36 -0800 (PST)
Message-id: <8c4cbb93-cba5-82b4-74c5-0ff1dcc214a1@gmail.com>
Date: Tue, 10 Jan 2023 11:03:31 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Content-language: en-US
To: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>,
 Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
 David Sterba <dsterba@suse.com>, Dave Kleikamp <shaggy@kernel.org>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
References: <20230108165645.381077-1-hch@lst.de>
 <20230108165645.381077-7-hch@lst.de>
In-reply-to: <20230108165645.381077-7-hch@lst.de>
X-Source-IP: 209.85.210.170
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10585
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=1501 lowpriorityscore=0 unknownsenderscore=20 phishscore=0
 suspectscore=0 clxscore=-6 impostorscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2212070000 definitions=main-2301100017
 domainage_hfrom=10012
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 jfs-discussion@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 6/7] ocfs2: don't use write_one_page in
 ocfs2_duplicate_clusters_by_page
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
Reply-to: Joseph Qi <jiangqi903@gmail.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AMrXdXvJDNVJzGLOc0X2GvVwdFjI8RfAavc5gUlJ2WeGpNuCy2JjwDpIY0RBpj1yDjgL50FOUueSBQ==
X-ServerName: mail-pf1-f170.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-GUID: -oJYHhsZD5lUXiSfyX3i60Se0sXutraZ
X-Proofpoint-ORIG-GUID: -oJYHhsZD5lUXiSfyX3i60Se0sXutraZ
Reporting-Meta:
 AAFkxmsKvZBUZqdRg7yb3t3kWzZ1XhmtUxDbQLiNozukItzoTmszxi9Q9p6KrEU9
 rmeBWYBHJe1v6YAYPK+Y0Tjw+JHshvkihPTXvFJZGa9QEWK7h30djE/pBjh7xRuM
 VdStBCS9HJeeqRB8UN29/E/gUZ8f4nQP5s4+IZkvSVpp3qLOjeHF8J/AUCFtbcc/
 fqGqMkUhNfz1NEmreTUQVR9D5F3aRrD6FXc5mnIL8KNtlsORTJE8jsg7xuXV2SN5
 9Z6t7JFg3CH0VMjmHyUBrqPn2hSCOqXU0VNdRsVFH0Hkc5UdES9Bhw9MoJCkpGEv
 Yg2gVKfeaTy9Ckh+FeTevwHxn3LdowCLRPd12aAA5eD1Afe0uhcezDhukO9UfSQr
 B3iO2ZiORpvVGA02etODeFCffic7YtVCZCaiqZ4Nyg89xDmf60EvnBJK1lgnYrdI
 ZNCxZB7mhRRgoUuzaTLZgCTIu48r5qnhyMiSAdLY/HCf77+kBg2aHzBIPhzCzuS/
 oOAdC5TNsbBIRRgDkpNNbz+GMHu9Qvo1VKv2chp3+245



On 1/9/23 12:56 AM, Christoph Hellwig via Ocfs2-devel wrote:
> Use filemap_write_and_wait_range to write back the range of the dirty
> page instead of write_one_page in preparation of removing write_one_page
> and eventually ->writepage.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/refcounttree.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 623db358b1efa8..4a73405962ec4f 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -2952,10 +2952,11 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>  		 */
>  		if (PAGE_SIZE <= OCFS2_SB(sb)->s_clustersize) {
>  			if (PageDirty(page)) {
> -				/*
> -				 * write_on_page will unlock the page on return
> -				 */
> -				ret = write_one_page(page);
> +				unlock_page(page);
> +				put_page(page);
> +
> +				ret = filemap_write_and_wait_range(mapping,
> +						offset, map_end - 1);
>  				goto retry;
>  			}
>  		}

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
