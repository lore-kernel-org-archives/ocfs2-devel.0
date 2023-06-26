Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A0A5EB64D7
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jun 2023 12:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oKMHH5/drbeDNHSlfev3ms3T9TuuKLLi6TDlg+ATxas=;
 b=khGtIiGmiwK0kNU2KU89E2KDfun7tqnCBoLqxS4KaXzqRT/zvmExtjgVY16SAjdVVG93N7BuuV8h
   hRqbL9r7/Jtlvhl3isSfxTZ3X76zBwlzwRMmolh3kTAdA7qRuBpO+QKvjG9gBroaWtur4lD8uHtF
   fw0iurC2UqzgQskETksRAFykPb4RkFAQx31huazYbLYWSSdxfncQG2dxhMWtoHreGnq8dXMkpWQa
   JH8gfx0ZqB73uof4P7x/JUsuaK3s3NmrsROMqFxtgDjH/1p1epFW+gco9Qv+d6HVzWOIwKu0wDN9
   QRc+XHTWh/yo8ClpbnmfdSR5nD2aEvzBsrJQHg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oKMHH5/drbeDNHSlfev3ms3T9TuuKLLi6TDlg+ATxas=;
 b=REpgRciOc3i/1st4RUEXCmtyAEcnakVjK3emOuMjWz88ao95YmaoS45FrW6+Xy1hYgK3seC7xMXt
   e41ptPjLk7biLFx4XVei0lwnkXsNaMIistF6FbYMMXtTOEQZ6NE8biCKPpWOJAnBmQgZ8aqPK+fo
   eehF4xXyupyP7RXn7CBGcLOlDj6QGLrfZjGW5wmDegfULTe8NeEipDc8fULN6mfu26bmnNc2qo4H
   z18t/45bz0sZWp1iSlQBD/TPYg0bJf0IDMcfXDMcTfaHxngZeWVFA5b1uqM/G3cRcemCCEnoAerK
   Q65BrTOFuiQlgup9d1FwDLcFumZuiHYaUbG4ZQ==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWV00EX710Q75C0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 26 Jun 2023 12:22:02 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=QsSJMAZtVZXkWomlSrdllY9FMvN+dViDBTPbQidYo/8=; b=aWgYj0EptSZlfXLuEr483t+nU+
 q8UEuBBhZLAzD0uNIL1JvRlmKknboUmTrQZo88tKIbVAtmLlOIVej5LP5OhvOY9LMzyJu53XAxFp+
 UOlravYeXRzFTBtKsApaa7IASSoeS0c1MLmx2PcK211ACZRQZwCKruz7n+knj1LwRYzGMqyI/4kQB
 K/JGjwnUki/32tsMPJh2LrnxjrGnA0IigXWv9l1s50SB15bTh0jzi44yxTP20c1Kb0P/poghgI39l
 IqXo7IQ76qkGkF/3w6uVzL3jADP8FwgeGHiaBU5gkJZ057UYX4KEd7HEmTRny1ITai+3m2LjsM6Xn
 6eQcyuUw==;
Date: Mon, 26 Jun 2023 13:21:13 +0100
To: Bean Huo <beanhuo@iokpp.de>
Message-id: <ZJmCuQFaaPHpgFuN@casper.infradead.org>
References: <20230626055518.842392-1-beanhuo@iokpp.de>
 <20230626055518.842392-2-beanhuo@iokpp.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230626055518.842392-2-beanhuo@iokpp.de>
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10752
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 clxscore=161 mlxscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=865 priorityscore=153
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306260110 domainage_hfrom=8763
Cc: brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 beanhuo@micron.com, hch@infradead.org, adilger.kernel@dilger.ca,
 viro@zeniv.linux.org.uk, jack@suse.com, linux-fsdevel@vger.kernel.org,
 jack@suse.cz, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [RESEND PATCH v3 1/2] fs/buffer: clean up
	block_commit_write
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
X-Proofpoint-ORIG-GUID: lGz98FNT0ZgNVQ6-nhMFN-3lI224J0I5
X-Proofpoint-GUID: lGz98FNT0ZgNVQ6-nhMFN-3lI224J0I5
Reporting-Meta:
 AAFCIBCH01iSJVNpPw+vOh+oYAG6nECpF4l/pFsAtKFwSy1khwHwzTajY1z2sfU3
 6/m0GoAsn7uZoqhdD/DJumN8hQ2fszOUszV6yDdXWv1jiWtWqfZSXaG4dRy3/rly
 L3A6DGGifLJRKAkX9xObodyMqOIc6fncqVuSPPEJ0KB0uc70pHhsPIF+aCyufyw8
 q6FOlEYSMY4poi1vUwkZdjwkVNpEGU5F3O7q7zxyyD5OL4thYRhccXdJ7VFWa76p
 AI/wnnxTIwjamB+u+gjR3CaDQLPbjps2fJMQWGdBBRR7fcGIc3yL6BJfHnHGiqyL
 4w2HNP/TyLOBGnlFOrsJkgF4TGOVjLi4WiMfUBYv0ctXctU6KmuYTY3uTCJAhjvL
 wyPg6GIyWgbIMNVuIXoKUHVStdVsrTGNwKoNZQJdB7MuOKrMBttEoJ/ryVjR3VvE
 eznURC7J1cDMeLaHe1pSpeE7LNcCTqWh3TcCfZy2/y3JGrdZJ+NDtolofb5g7HTP
 QZDrnFSk8rvDpwtG36w6hRCD9Bwpu12yqDj6aE6sV0I=

On Mon, Jun 26, 2023 at 07:55:17AM +0200, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Originally inode is used to get blksize, after commit 45bce8f3e343
> ("fs/buffer.c: make block-size be per-page and protected by the page lock"),
> __block_commit_write no longer uses this parameter inode.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

I'm expecting that Andrew will pick up these patches.  Unfortunately,
you've sent them right at the beginning of the merge window, so I
wouldn't expect that they'll be picked up for two weeks.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
