Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403AEC4332F
	for <ocfs2-devel@archiver.kernel.org>; Sun, 23 Jan 2022 05:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=TTbjyLn+1EPbyS3wB7p44qN/f5n7XefLbLi2r/H8QNc=;
 b=M0GS1XfJiFCfpaaqkRCbaC4VJhyq4fmext25nb8ow4UjVvdpeWcSleGRxg/5+UORkCwLyKlcX8ve
   UsDudipc1TUrMP31iX0+/1O0I234BK4UC5cKXHaWY0FU/9QwFzaj3Yo+a0MHAG+/R0QeszRV7K+j
   vLCifpXItHM1n4YSsJcPXMsy31kfZKUBsxac7OBRerFSQGpSVj/M//dJ/yRZfXf+8ZpQMAsKm2XF
   pWbYqoGsjfZVY4wHm3rLXbnWwETHpvSgrj+kZCW5pIlACozZoEDFoj4MuGB6c36DbDM2emv/DMJo
   whbFKtQCvytuyDvth7ZjR+Yt3kYy2fzqvE4fnQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=TTbjyLn+1EPbyS3wB7p44qN/f5n7XefLbLi2r/H8QNc=;
 b=VyYe3vF7wFUIkJ3AjlCgYMupjWDeX5mYTtStwgSugJAzdpsMrvVQ2fJwQEbkyEZgAcZNP5VO5UnQ
   EjGYgk03yXTek/Xl5IyDVVR3sIJAvOxBh2Quy7L5Dzhlq6CFk25pBEkWoJhwR8JMJDQ1yfX5EO+5
   UULgaXmnckg4LcWWtUbEWPo/Hnet8Nknwu/iQjjIXz/Z6s9tqgb3hClr6mLkB8Pmem/3VCMX0Iay
   /S44zHTzezi/75TWJ1WWbKdhW/687p54SfdzJGN6ax5UTk0QUwM2ZSCBrZutdGo276Er9VgyZy1m
   HiCu3F5l8AsSM41oBZkGaAQeTqJtojtLn8GkUw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220104 64bit (built Jan  4
 2022))
 with ESMTPS id <0R6500P0WE0A3V00@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 23 Jan 2022 05:31:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to
 : cc : subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=UujmKVy4jwgACE188AGR/u+GGf79Te2Rl4MenZ1raB8=;
 b=yILmqvl8LsKzZ82u+yC3KsexNf3dOdtqwEMQKtP4j6KJcNtn0PARR5jchv+7hg34ZWXj
 mJfXDvj65L+qHVijgJXyeb+17TJ67YQHkWRSAysJGSE2hpfuzmEiSHG/JLDDS1PvM31d
 YoI8BaziXC8HdM5XcOhWyXCOvLNCUj+NAbhUHtOZIHd2121zhUSyo9M5v81AYjRC7XD2
 BgrVgs/OwIw93c+8LpWrmmfLFNPTsWtnTx5x4GANcnXtmyjYLrc5xuyGjNgibo1nphNW
 4olIxOxjjI+RIgq5YazDlapmdGqdgwt7oL+4l+SZ2rMGjrDDPQP7OlceUTO95MbHOjhC gg==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=gautham.ananthakrishna@oracle.com; dkim=pass
 header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNMv8ATitBHooXFkE2om3z9FcXtNmR42xXAO9qyNlm0bq9ZjmoZuEtPzdszRTgJylajMq59AwCSbWoq/k6nXGCxRGrrLeDwXSMVwoL5q7ylwClFD+3Cj41/Owo+i/qajlbBRwrSN2ql6Z3WtAIMc8svJTnEku2/zfIQbmWaF/m9OcGmhQyjxhtdZUN0vIflJjSaMU8bm3yi+zskoM4uKO4ewl07nO5uCXfj+HL1S4DxORkJd9GRLGjMXk38J46M41EYAYdZMFu+x2rPkQAVJPou2wG4f3zimZTBOzPbklpj1FEn1H6z+maNIevB1UuoAJqvlGbe5Jq03gHLVFqfKDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UujmKVy4jwgACE188AGR/u+GGf79Te2Rl4MenZ1raB8=;
 b=hFYsP2wAG4S5Y2u6DwyCsfMIJ6XAhOMDoYd34yi6zQZNR5AdUxTf8NzkuVLyTy6k4pE8Og14xf3KTYmqV1QX7DHLRC2CWo1/J8zT0+bI17mnkyts76q1H0ShwmebYGKiKUJVndhCwPuDONqjgA9ZU1BMAIkszz6JmgGLLD1Gf+n5Jb1mtL/03YSoBLD6FI22QksdNNjifZ/cuQGTSidNudtenOUXZ+7V8we+mIfbIlfo6ixQZsFlnjkhmHJvhohVmzXx+V9oRDxIDl3SO+5SAuJmwSygbU/6xJPq0HPJi8qWAr4ugPB9xzk7OTCfg1mgdfTXmIfYiwVdIa4COrau/g==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UujmKVy4jwgACE188AGR/u+GGf79Te2Rl4MenZ1raB8=;
 b=iDdKey82Ic1eu3EcZkLZp3WoE0Uk9VsEH4AMyKOP/YJ/zT9xFMFrvr1kA1sKg4+hNn1vjsBiCKKYGPn+j3tzAOG4GRzX/ID8KNO9tlxfaTsDgMugp15gHecI4/s42U5kZtXGmSlxzAZr2ln0gIkzpbgYtcsqxV4Ktm0ZWafVWwQ=
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "tytso@mit.edu" <tytso@mit.edu>,
 "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>
Thread-topic: [PATCH 2/2] ocfs2: fix a deadlock when commit trans
Thread-index: AQHYDpY4QxT3B/KhD0KLG3FGeJTJ0KxwFvKQ
Date: Sun, 23 Jan 2022 05:31:01 +0000
Message-id:
 <DS7PR10MB487883FE7025BE9FD4623C39F75D9@DS7PR10MB4878.namprd10.prod.outlook.com>
References: <20220121071205.100648-1-joseph.qi@linux.alibaba.com>
 <20220121071205.100648-3-joseph.qi@linux.alibaba.com>
In-reply-to: <20220121071205.100648-3-joseph.qi@linux.alibaba.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach:
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:DS7PR10MB4878.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
MIME-version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2022 05:31:01.4756 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10235
 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201230042
Cc: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
 "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix a deadlock when commit	trans
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
From: Gautham Ananthakrishna via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce0d548f-8520-4782-3488-08d9de318b28
x-ms-traffictypediagnostic: DM5PR10MB1948:EE_
x-oracle-tenancy: 1
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 m3x69gYxmwf2VOZaXwAkCVcEgvo/fiPkWbz88Ft6Us/QfjxHUdnvv7wQOnYsT90zkg3He4Wa37NehUqUwscjaU1A4afGU9Cl09JTUf7J7/rNcGdpOD8w0v8nJ55v44zuqYRRu3ZvqGB3Z5ptuBiQUcL/lUZrmbLfrfMXJG/XAAtY7o/CUJda9DisUudeQs1zoWhXTxSy9X4CMlwfze9HUAyFW4wCBhWTzE9/h2Isjoxt8+zRDbuF0CpuhneqfkqIrsnSplj+DkKrUL1WlrnvuU1GU6rFq/klCqwnaHYwJIxJIRGr5FxXYupjnLEFvGU+hJWeHb+MONFyzyBpPWCZv/jP4GeouW0VAhS5kik1JgNt+cVC7By6aYLrEvZIKQKBd0emRqCJSSwCFq5psMKYk7VzCcd8nJDLwb5zH6S7fBWn+fnh9pXV0e7UvsVeJ74ua8a9o5Arzbs1L3Rks5WW3SfJY8fcu+ngfIXbeFE44hqDipTuRJuZ1eRVbfywRhkFiaFya8iHqguPfMPfwDiT4GoZLTV5jfCS98jx3eePPcp92P8b0gUFKLmDlpNRTQa3MdCxx4So+bOJxlqzviJEeDbo0P3muIQNquRTdsASXgU=
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id:
 ce0d548f-8520-4782-3488-08d9de318b28
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname:
 WD0kpoGJj19J0Hy/E0XEgGgYDU0yu8heNbU0LYIMARUiB58yGi2/Dm9poJKhqR8JdrURKF5mhBbVouPbqvuIliAU7vMaBEX8Okn7/47QufwFmXKzBU0P27UCmGJjQiCh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1948
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: DS7PR10MB4878.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC:
X-MS-Exchange-CrossPremises-originalclientipaddress: 138.3.205.55
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating; SFV:SKI;
 SKIP:0;
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: DM5PR10MB1948.namprd10.prod.outlook.com
X-Proofpoint-ORIG-GUID: TbQJ5H6osnq8AyGUGPG53_uit3oGeAJw
X-Proofpoint-GUID: TbQJ5H6osnq8AyGUGPG53_uit3oGeAJw
Reporting-Meta:
 AAGxALXnW20UXF0fXQkWQCV67skxii4TEA/PZRnw0RPIxhkxEPDrgNlnLFHrek7m
 lvCNKGirMgV0fSUl4rG0e+v2gpe5YOhPzRiTdW6x7UbhY52vKQO9Q2Fp3Gp45Pl4
 AVGUv4gRg/x4oM5boUqBKZRG9c7Q0lm7l8N8VpHA4GVMzqhxfl/mS7fuq9vvmi1/
 ixECsMahEOtGPyzWglaFq4m4zv2dBE445uQPuaLylg6ZqVNwkjP92PRqGtybNiTg
 PeEKVdOZYtHWEAjIJNTUBUXPozUQmK0Z8wrzk/jrTLmpkcqT1ZoXzJYv3ktLihDV
 0+Ug93MfJ03MmQRvZqmOhWrDs8EFHpi/kPIuoXDVMI+EBjAO1q+pQqpEwgnQcBMI
 skmcJkxUnBHgzG4YsuzDQIDXisXx4BxVwmfiu9/SizgQOGsH/59x41UyyThPWwsj
 IRIDrqdAF5xqTZlVOmRhfEvycvgdP2he0B2xFsrYAs8GLKEPsU26M4UXaArYe1M2
 pW2BHI56A377W4J4QkfSBA0ouZ5rNeVaGYcwzDTUieFH

Hi,
This deadlock was originally reported by saeed.mirzamohammadi@oracle.com  Could you please add Saeed as the reportedby.

Thanks,
Gautham.

-----Original Message-----
From: Joseph Qi <joseph.qi@linux.alibaba.com> 
Sent: Friday, January 21, 2022 12:42 PM
To: akpm@linux-foundation.org; tytso@mit.edu; adilger.kernel@dilger.ca
Cc: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>; ocfs2-devel@oss.oracle.com; linux-ext4@vger.kernel.org
Subject: [PATCH 2/2] ocfs2: fix a deadlock when commit trans

commit 6f1b228529ae introduces a regression which can deadlock as
follows:

Task1:                              Task2:
jbd2_journal_commit_transaction     ocfs2_test_bg_bit_allocatable
spin_lock(&jh->b_state_lock)        jbd_lock_bh_journal_head
__jbd2_journal_remove_checkpoint    spin_lock(&jh->b_state_lock)
jbd2_journal_put_journal_head
jbd_lock_bh_journal_head

Task1 and Task2 lock bh->b_state and jh->b_state_lock in different order, which finally result in a deadlock.

So use jbd2_journal_[grab|put]_journal_head instead in
ocfs2_test_bg_bit_allocatable() to fix it.

Reported-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Fixes: 6f1b228529ae ("ocfs2: fix race between searching chunks and release journal_head from buffer_head")
Cc: <stable@vger.kernel.org>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/suballoc.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c index 481017e1dac5..166c8918c825 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1251,26 +1251,23 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,  {
 	struct ocfs2_group_desc *bg = (struct ocfs2_group_desc *) bg_bh->b_data;
 	struct journal_head *jh;
-	int ret = 1;
+	int ret;
 
 	if (ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap))
 		return 0;
 
-	if (!buffer_jbd(bg_bh))
+	jh = jbd2_journal_grab_journal_head(bg_bh);
+	if (!jh)
 		return 1;
 
-	jbd_lock_bh_journal_head(bg_bh);
-	if (buffer_jbd(bg_bh)) {
-		jh = bh2jh(bg_bh);
-		spin_lock(&jh->b_state_lock);
-		bg = (struct ocfs2_group_desc *) jh->b_committed_data;
-		if (bg)
-			ret = !ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap);
-		else
-			ret = 1;
-		spin_unlock(&jh->b_state_lock);
-	}
-	jbd_unlock_bh_journal_head(bg_bh);
+	spin_lock(&jh->b_state_lock);
+	bg = (struct ocfs2_group_desc *) jh->b_committed_data;
+	if (bg)
+		ret = !ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap);
+	else
+		ret = 1;
+	spin_unlock(&jh->b_state_lock);
+	jbd2_journal_put_journal_head(jh);
 
 	return ret;
 }
--
2.19.1.6.gb485710b


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
