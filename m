Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78947C61DA4
	for <ocfs2-devel@archiver.kernel.org>; Wed, 15 Mar 2023 17:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ldwHpC49cRlTnzZf882x/AOF4uBH3tcJphTxabX+iUk=;
 b=yPZQHYG03oGwZ+9/7lGl5nTGjiNHaxXZA2bpwZa4qbT4iEv4YvYFUqvcv0OulHoFGJAzQ8gACdbu
   eKTS82ta9VyKJNi+tHd8MHsOKnAYfO7MHPdbuy76b37IvW++ymXZdKzWIf8SATdCi4gmONorU1jg
   vIuc02Jw/xFivdxK0sw4Yifk9cqBKJMeqLkHbwlV5yMKSJ04SoRG22JA2qK4QtcPJXa+U8tmJe+f
   FrwmrmZ51tl1n/MxIXDuJT2hCXdAZsy0hDTKIGbWtyKZIb1m2NqJL/YiVbFeQESakNg63aCoEtA1
   x5QX2/bIdDja9ocDoljpQDlP/aeKfWHodR/w+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ldwHpC49cRlTnzZf882x/AOF4uBH3tcJphTxabX+iUk=;
 b=K4Axl/4QVHx1QlUCZEeFLseo5aMkX/PhJSVBE/GODsMIpkiVzVpTQDy7ueLf6KOk/uC0BVqIsYhk
   2AFVuvbxw5cOVXqdrdDULNS6AqVhnyNxARLKoAComimC28S4+Oz5o5GY2Xf7JQTIdXfZj79GxHdu
   pRBge9fwqHrels2Is0pkvOqhWSTzP1hwTRPi9wtZdk79TRIxUXKeLyZiihZGqOf0/OUXP9svJIvb
   THZiA30hwctn/+QjkfJh03/cLPdBKSHIuYN3+HgPJzO+Y1ZwuCns1raFqAdSFJB3ahuTQmw0JUEC
   BnE8dv8yZvXw2CA/E/PpDHxRsfVKNUwqJjfkGw==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRK0078FOJLY990@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 15 Mar 2023 17:28:33 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1678901298;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=sxqIHWYkEkuemUo7+5mdkg6JX3qcugurtqVPin+TXEw=;
 b=c2BMyTZ/P44y3QMNmZQBesAQkzGVsiyJ7ZJdVC2lYXk9cUONZ3Xkn752OyE+45zRh0QjUy
 r4JsaPW+P2vqh4vmk5Gz55es25D4XuI84ZmwSDUDqJirlkbQq3P9Fbqg3QBEOuURf5txsp
 wc1dLNKGCHNrqVl3haltcdwyt4zBuwY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1678901298;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=sxqIHWYkEkuemUo7+5mdkg6JX3qcugurtqVPin+TXEw=;
 b=nPOuWyJmEGYn3aK+3Bb4YzjNXoyCmmo8CDrMWQQQfgh6MR14T6+EXCKpkM4sKjz8itJ2lJ
 3578I7XkabJ4HhDA==
Date: Wed, 15 Mar 2023 18:28:17 +0100
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20230315172817.egezft3msc5z4omm@quack3>
References: <20230314140522.3266591-1-yi.zhang@huaweicloud.com>
 <20230314140522.3266591-2-yi.zhang@huaweicloud.com>
 <20230315094826.okdarxaapjyqmlhq@quack3>
 <8c4ff3ab-4af2-58ed-4d08-3050c044f445@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <8c4ff3ab-4af2-58ed-4d08-3050c044f445@huawei.com>
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10650
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=4 clxscore=144
 mlxscore=4 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=4
 mlxlogscore=133 priorityscore=160 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2302240000 definitions=main-2303150146
Cc: Jan Kara <jack@suse.cz>, Zhang Yi <yi.zhang@huaweicloud.com>,
 adilger.kernel@dilger.ca, yukuai3@huawei.com, tytso@mit.edu,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v3 1/2] jbd2: continue to record log	between
 each mount
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
X-ServerName: smtp-out2.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-GUID: 19diqvG1lAZp9VqdaBZakB5ht5Ql_bJX
X-Proofpoint-ORIG-GUID: 19diqvG1lAZp9VqdaBZakB5ht5Ql_bJX
Reporting-Meta:
 AAGju1xL4kPhohyT1c/krT6X+FEe2N0/DqWWD2fXeMOcnZEtPdz6+vvKpWlz5d5r
 ZhnDdfqjgmr48IIlEDQd7M9615xRQiIMGiGmAAnlUrwdJLr4Bz8K5Z6mFRYBUoDt
 MNV1EuNbuLNvPOfU0mfj8y/V1ls1RnNNvpMbXkvVt+dIcvhaMokXhHY0soFkh/B1
 fMlaZ6hUypa9POmNVcJKLJvXMX0h3g8E34KdwiA0eCLXvKLnoUqI9TufRlNJxqRa
 bNqU2uiTZtZfaOwNRAVMjoCo0gp1m14ztXR3nQjlwXKAvjCRlzc+6vuSSUm1P0z7
 A0lRFs/tudB6/aMwocdW5rueSIs/f635xCo0+qipy89ChQkDtRJwrKnwEcUTyP9o
 HILo9bCbEbp/68D9mo7VSce9hHF7XLPSZR9du9s7c0i1s+M+QSmXXAmdvyI0Y5/W
 phlqWNu3Xtmf1m6m+7zOH02Rfo6QyO8l14WxqlzDA4s3YMB6e75VPzmjSLaG9OQ+
 ZyHHNKmAS3iMUxGGYDa4X5HBpwLsgRMU51CdMGeciXNi

On Wed 15-03-23 20:37:32, Zhang Yi wrote:
> On 2023/3/15 17:48, Jan Kara wrote:
> > On Tue 14-03-23 22:05:21, Zhang Yi wrote:
> >> From: Zhang Yi <yi.zhang@huawei.com>
> >>
> >> For a newly mounted file system, the journal committing thread always
> >> record new transactions from the start of the journal area, no matter
> >> whether the journal was clean or just has been recovered. So the logdump
> >> code in debugfs cannot dump continuous logs between each mount, it is
> >> disadvantageous to analysis corrupted file system image and locate the
> >> file system inconsistency bugs.
> >>
> >> If we get a corrupted file system in the running products and want to
> >> find out what has happened, besides lookup the system log, one effective
> >> way is to backtrack the journal log. But we may not always run e2fsck
> >> before each mount and the default fsck -a mode also cannot always
> >> checkout all inconsistencies, so it could left over some inconsistencies
> >> into the next mount until we detect it. Finally, transactions in the
> >> journal may probably discontinuous and some relatively new transactions
> >> has been covered, it becomes hard to analyse. If we could record
> >> transactions continuously between each mount, we could acquire more
> >> useful info from the journal. Like this:
> >>
> >>  |Previous mount checkpointed/recovered logs|Current mount logs         |
> >>  |{------}{---}{--------} ... {------}| ... |{======}{========}...000000|
> >>
> >> And yes the journal area is limited and cannot record everything, the
> >> problematic transaction may also be covered even if we do this, but
> >> this is still useful for fuzzy tests and short-running products.
> >>
> >> This patch save the head blocknr in the superblock after flushing the
> >> journal or unmounting the file system, let the next mount could continue
> >> to record new transaction behind it. This change is backward compatible
> >> because the old kernel does not care about the head blocknr of the
> >> journal. It is also fine if we mount a clean old image without valid
> >> head blocknr, we fail back to set it to s_first just like before.
> >> Finally, for the case of mount an unclean file system, we could also get
> >> the journal head easily after scanning/replaying the journal, it will
> >> continue to record new transaction after the recovered transactions.
> >>
> >> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > 
> > I like this implementation! I even think we could perhaps make ext4 always
> > behave this way to not increase size of the test matrix. Or do you see any
> > downside to this option?
> > 
> 
> Thanks for your suggestion. Indeed, I don't find any side effect on this
> option both in theory and in the actual use tests on ext4, I added a new
> option was just from the safe point of view and let user could disable it if
> they don't want it. I also prefer to make ext4 always behave this way.:)
> 
> I would like to keep the JBD2_CYCLE_RECORD flag(ocfs2 also use jbd2, I don't
> want to disturb it until it needs), remove EXT4_MOUNT2_JOURNAL_CYCLE_RECORD
> and always set JBD2_CYCLE_RECORD on ext4 in patch 2 in the next iteration.

Yes, that makes sense.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
