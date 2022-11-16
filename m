Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02BAAC4332F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 16 Nov 2022 13:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wLyGccL3+pDPW/722WRlT83Yj+Tqq7PLD77YUuJZ9ts=;
 b=CtRsvLO351wDzNVxJ7c0ijD2jM2wHIsqcmAa4SnIZPZbHLBcAeJ8NCSeT6+Jua1f6kWFVGYuM0M7
   r95Cp22/eCYPD4MLGtHQdEiFxLuvWvH1aAQSa8EOh1Id5RTNtOvTh6D8/GYls9laiFGBWN4vRiel
   O3noI4Q44Yv0h7QoewvaHZrodTxMw80wq+YQeLZ3ZeZpn40RT2c5PAljT8nmgGbuH9+CQhYYTI2g
   Sm4X3g4yZw1DhmtaxbdJOsldHsxj1VE1ElqH+P2+ktKQY87K2UDJTUE/izVMXxYv4jlCZ0L1V+od
   7V2ifws4Foo2+55lUzf+/sRoP46T/IT/0B2MWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wLyGccL3+pDPW/722WRlT83Yj+Tqq7PLD77YUuJZ9ts=;
 b=tw4qq7rVkUwN+r7Yza5oKyZo4q4jV4X5or9nfmZWR2PwgGJYUyfQDLCW+a1ZMZM6Iztp3n4oMWed
   +wHqqO9okQsBGjFpiLuNmN+BPpeljD6jLldNGDSh9/K12N65EnE0iXCN9lQdX8F/Ssy4DeweE2QM
   yIa4U4RwFOsarkjKEbDf/5y4BMybH1tlBZ61lgsh5715vRjZ6kVPSt8MpAKyBvmiZvORbD9pU8oR
   ujfw1SbPAUlvxYWArDJO/prwS2M0IdbDy43HrizRIGAgHm7uyh2XN/J0b6sh0lrGoHFBYkotz3BS
   g1RaJKF9J5fjTgw/gOGLIG7Wm4avh73B2jWRYQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLG00JW614H8BA0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 16 Nov 2022 13:50:41 +0000 (GMT)
Date: Wed, 16 Nov 2022 14:50:16 +0100
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
 Mingming Cao <cmm@us.ibm.com>
Message-id: <20221116135016.GA9713@lst.de>
MIME-version: 1.0
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Source-IP: 213.95.11.211
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10532
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 clxscore=286 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=713
 lowpriorityscore=0 adultscore=0 spamscore=0 malwarescore=0 priorityscore=30
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211160096
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] generic_writepages & jbd2 and ext4
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
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@lst.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: verein.lst.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: IvzHadDF09fAQvt4rpdDT-Aaz2jVqiKZ
X-Proofpoint-GUID: IvzHadDF09fAQvt4rpdDT-Aaz2jVqiKZ
Reporting-Meta:
 AAFPVm8RdW26hQfb87AtvQcGC67e4VqWUU10DSdyJxatOdb7vcBRaiepGKWVXT3I
 8NLoqKHQogVBz9fq6yMkuwhVuAa6uox/ZhUdSyrbNJ+agwDlDSr0nXcTJBlRAydP
 nOCM3UBsNoDd9KogucmE6buDhxhe1mhNAjdlBDbx8uoK3hVlHL8o2ASWzrLlwwac
 x/Lq9R6tlTTFRTY92+VaepbPAASRCc4QMcnF6zeUrd5noZnjerrQ0oGcXnON1ibh
 yuRUw5fa5eOe/1V9JYp26zZldH24I8WTxRitguWFjMfFV36I7U7/Mf/9p4oK+gku
 VhknwwnG60cnIOzsxSGhPdRzXpH3QaS+6yyvBQ2UwFs80WWeIGQK8bq/EpXSBet8
 9b7yUvgsNfWEiOFQXFRqESM1qVmQGiXYQK20PzCybp8HOquYJA5qZxIJvUKglQfT
 yIyiwkkDbQyJoWpZgPIcrTGgtm8tDNZe41M329bqxGjM3kaKlX/DivtqQ5yu54Pn
 rdy1BpJT3IyB5DSNFFMUOzS9EaTZ3iPwa86/vcqobRSJ

Hi all,

I've recently started looking into killing off the ->writepage method,
and as an initial subproject kill of external uses of generic_writepages.
One of the two remaining callers s in jbd2 and I'm a bit confused about
it.

jbd2_journal_submit_inode_data_buffers has two comments that explicitly
ask for ->writepages as that doesn't allocate data:

/*
 * write the filemap data using writepage() address_space_operations.
 * We don't do block allocation here even for delalloc. We don't
 * use writepages() because with delayed allocation we may be doing
 * block allocation in writepages().
 */

	/*
         * submit the inode data buffers. We use writepage
	 * instead of writepages. Because writepages can do
	 * block allocation with delalloc. We need to write
	 * only allocated blocks here.
	 */

and these look really stange to me.  ->writepage and ->writepages per
their document VM/VFS semantics don't different on what they allocate,
so this seems to reverse engineer ext4 internal behavior in some
way.  Either way looping over ->writepage just for that is rather
inefficient.  If jbd2 really wants a way to skip delalloc conversion
can we come up with a flag in struct writeback_control for that?

Is there anyone familiar enough with this code who would be willing
to give it a try?

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
