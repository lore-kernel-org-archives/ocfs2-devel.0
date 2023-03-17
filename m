Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD9C9C74A5B
	for <ocfs2-devel@archiver.kernel.org>; Fri, 17 Mar 2023 11:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=X+94UBxWNgT6ApP3yrrbbENkJ0SvDxtK7anQI+ogp64=;
 b=0o3Ojnfdn/tDtlpS5sIF3ITrEYggbqSLGGzuRchJ35oqkwwZ64qFLrwXYr3fmMitq/hBtIfp070K
   W5/H7cRz8IKDDjPnIkFn46kS3ykvPQ1uSFlS6YV16gbaRQ6IOytUE8sjMKfxbXjeGBshOjptWVps
   +ThZG2RwpbOCerdA6vwKzmN+d3C0sDc+77hzFuS0zoDI4sjwbAUOiPNnteeljHcqt/o+QSMDOAXJ
   UT+7/qTzJrvQI0rKlamKzB+DpiRu2OW/+ED3hCA4kxxlY+t46NDWo0rktPGCgNxB2RzK19svLSJQ
   bd1zufLKOa4vw+iwcx3zPQBkiitbsw9DSZYl3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=X+94UBxWNgT6ApP3yrrbbENkJ0SvDxtK7anQI+ogp64=;
 b=PI9Z2lT564d7vUGWMJG2W0a3KKjSdWQcxnFLe2usbkssqiYfMaAoaFK2hYEX9xKiIBR5e/u30Da4
   2gjiEwlT9Xt1u9VjgelJHzHSTBuQySgTz9oAcvf1DNEjEz/N4I7V7O++Wm5fSk1j6FpC0Db9kXHZ
   q87UbDSAMVu7Ip8197vJhgi1gkKBzjBCTzJMzVezzpeabCfZzg6swwIiLvecxsiTh126DNRhEFNG
   nBbUswA7lLyQxoLOKgxRoK6dmwTUgDFQL2R4ULKejuWxD75k9Pe/v/Xn7ohVztWasu7uPIiJaI7w
   jtNAmGkKAVcu8g7p9K2g0VmGbLsx18Mopw6uoA==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRN0036RX2ULS10@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 17 Mar 2023 11:25:42 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1679052329;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=fWG+Yn5EAQxzdh2xDZYpvdlnWCphXvTLSc2lBNlF3b4=;
 b=HN3gdng9O2oxG8BCnEjOLaPeZJECYZjEqNTn2U2UukRydeAizDCEGsjruyq3/C0cKjzZjB
 qhZh5BaCaMfSnbSS+4XIjOkT0OVbuNJwtWY7Uc2G44U7CDOyC+5LlfkGsTgy2S2bEZkxmA
 3HTtOyAKBlNGsjgBhp0Ho5qIYKJm574=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1679052329;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=fWG+Yn5EAQxzdh2xDZYpvdlnWCphXvTLSc2lBNlF3b4=;
 b=UpOAL8dyObsfBmOFjpfYutrPUMzJZ8mQH5jP0HF3QEGtfNSfoT0kJjoSVEUoSOK3HrBcz7
 ZLgxMiBiUSs8bMCA==
Date: Fri, 17 Mar 2023 12:25:28 +0100
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20230317112528.cig7fczuoezn23wy@quack3>
References: <20230314140522.3266591-1-yi.zhang@huaweicloud.com>
 <20230314140522.3266591-2-yi.zhang@huaweicloud.com>
 <20230315094826.okdarxaapjyqmlhq@quack3>
 <8c4ff3ab-4af2-58ed-4d08-3050c044f445@huawei.com>
 <20230315172817.egezft3msc5z4omm@quack3>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230315172817.egezft3msc5z4omm@quack3>
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10651
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=1 malwarescore=0
 spamscore=1 lowpriorityscore=0 suspectscore=0 mlxlogscore=227 impostorscore=0
 clxscore=161 phishscore=0 mlxscore=1 priorityscore=118 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303170077
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
X-Proofpoint-ORIG-GUID: 39mbOOnnFbzWkdWqMC2XgIiebbyUK7Lg
X-Proofpoint-GUID: 39mbOOnnFbzWkdWqMC2XgIiebbyUK7Lg
Reporting-Meta:
 AAFJ7E7bWM4t4zdgSBmytzLfZPmLh/FMNsKQA2+XqX1Pnym4a7SyNuTxNeZmSylk
 DBmjSmUeZLLiwjJc84LKjT7UDzx1Ul2bvX1E+H04mATndUvYfYzCMEdNT0gjDXaR
 DqFngU7xWbPKFNDKrTv4dUlOy3XN97a1FtAiqldgohrB/qnEF9wpOQUQHuLQdgWs
 56vIVCD8bYkzAxFKaVqJOFJFuayCFaCOUosF0zb2jTArbVIg0BVBvRt66j6oIKLk
 bt33duzn+FvFtr3+SM0SAfRMOIlsVeME82/dEKK0v8xtfMxvQuGJg4vq7/ZTrMhx
 OC7X117r9glQ+IKTCX+3fENaaAdIxplJ3nMawpX/xqh4E8A2lL5Ie+7HomwjXRR7
 Sc71dxxWqRT899bO46cAMwLqAK4jWbVepSdNoXZwiwiddesEY2E2DgSf6PBfb/Pi
 njMMULtj7vmKkW98O1RPaXhaIbJHIbCpCa89yxxYWDR2iT1Kc8tX8dP1ZKf05+7F
 EaXEYv8grVNMIgnJ+DObWaDUZ8yfu/9F1MhSLkZSESM=

On Wed 15-03-23 18:28:17, Jan Kara wrote:
> On Wed 15-03-23 20:37:32, Zhang Yi wrote:
> > On 2023/3/15 17:48, Jan Kara wrote:
> > > On Tue 14-03-23 22:05:21, Zhang Yi wrote:
> > >> From: Zhang Yi <yi.zhang@huawei.com>
> > >>
> > >> For a newly mounted file system, the journal committing thread always
> > >> record new transactions from the start of the journal area, no matter
> > >> whether the journal was clean or just has been recovered. So the logdump
> > >> code in debugfs cannot dump continuous logs between each mount, it is
> > >> disadvantageous to analysis corrupted file system image and locate the
> > >> file system inconsistency bugs.
> > >>
> > >> If we get a corrupted file system in the running products and want to
> > >> find out what has happened, besides lookup the system log, one effective
> > >> way is to backtrack the journal log. But we may not always run e2fsck
> > >> before each mount and the default fsck -a mode also cannot always
> > >> checkout all inconsistencies, so it could left over some inconsistencies
> > >> into the next mount until we detect it. Finally, transactions in the
> > >> journal may probably discontinuous and some relatively new transactions
> > >> has been covered, it becomes hard to analyse. If we could record
> > >> transactions continuously between each mount, we could acquire more
> > >> useful info from the journal. Like this:
> > >>
> > >>  |Previous mount checkpointed/recovered logs|Current mount logs         |
> > >>  |{------}{---}{--------} ... {------}| ... |{======}{========}...000000|
> > >>
> > >> And yes the journal area is limited and cannot record everything, the
> > >> problematic transaction may also be covered even if we do this, but
> > >> this is still useful for fuzzy tests and short-running products.
> > >>
> > >> This patch save the head blocknr in the superblock after flushing the
> > >> journal or unmounting the file system, let the next mount could continue
> > >> to record new transaction behind it. This change is backward compatible
> > >> because the old kernel does not care about the head blocknr of the
> > >> journal. It is also fine if we mount a clean old image without valid
> > >> head blocknr, we fail back to set it to s_first just like before.
> > >> Finally, for the case of mount an unclean file system, we could also get
> > >> the journal head easily after scanning/replaying the journal, it will
> > >> continue to record new transaction after the recovered transactions.
> > >>
> > >> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > > 
> > > I like this implementation! I even think we could perhaps make ext4 always
> > > behave this way to not increase size of the test matrix. Or do you see any
> > > downside to this option?
> > > 
> > 
> > Thanks for your suggestion. Indeed, I don't find any side effect on this
> > option both in theory and in the actual use tests on ext4, I added a new
> > option was just from the safe point of view and let user could disable it if
> > they don't want it. I also prefer to make ext4 always behave this way.:)
> > 
> > I would like to keep the JBD2_CYCLE_RECORD flag(ocfs2 also use jbd2, I don't
> > want to disturb it until it needs), remove EXT4_MOUNT2_JOURNAL_CYCLE_RECORD
> > and always set JBD2_CYCLE_RECORD on ext4 in patch 2 in the next iteration.
> 
> Yes, that makes sense.

FWIW yesterday I'v spoken with Ted and he also agrees that we don't need
ext4 mount option for this.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
