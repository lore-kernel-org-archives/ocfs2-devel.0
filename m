Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B91C761A6
	for <ocfs2-devel@archiver.kernel.org>; Tue,  4 Apr 2023 17:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3LGLpTC7ngiBNlB7Sk6um/mJCG7zlq43INHVRNwLdFw=;
 b=lc63iDTmCz3JXC6uB+jxqsP3Q+ozDGqF1RYQN3le5FypJ0RBF6B/8VGavD5EJ8/F4Vv3nvSAgHab
   eicGD5WfcIjQH0WnacNGtYKVPPLdyDOIjVU+AIObRckvLPm3cI/XfIT3s7fOFEXdH3gPGY7V3Kb0
   ktn8UxmxuNDqfVj6Yimx0ENT/So10b4svLmsPbys7gnaXvOe6x89WuTsFwR3nzrjJOl3sljSgh1d
   aHcZT5LpJAaOS+o4FNj6AziDfq7xB3PI8GJTgPI6YvibJPy3F/IkoB59lbhvXjM8Kwk2Z8Sy5hrT
   X22bECaYF8NQRnGSpBIcyoXSRb081hFpQdRUcA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3LGLpTC7ngiBNlB7Sk6um/mJCG7zlq43INHVRNwLdFw=;
 b=FPua8q7f3GNPtgHGD3vU/r5H/js+HrrIQngpCtp6RuG37TZHieCA8M1XpuXdR0qyi9tkO0FAYGAC
   lOKEBBt0333mala+wbeMVTyfn3frCQJdwsqXQ58QcHdKbTC6yoZwa/ka5qQFBTsuAt1PimUdRy9Q
   a6epDSfJb7XH2qUioPWzsusSNvl27epxKkmuV3pGYM8F//+t6TWgd7/oy9fikcURNiGIDl5Yf234
   SP9lRuEMdrgl19Zp0RyPvmvvlugBASKLdwPRTJ+SIPdHjEKCOoN3tCiJxi7EZxrEgZKQTmGs4PSw
   WYQTwmg2I/KNAV1hTyT5MOQvllR3uMFX1aqhrQ==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSL00CHAPOTJ440@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 04 Apr 2023 17:24:29 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1680628461; bh=q0SEd99SwGnQv2q9V/VBWUZ22Egdd8W2yS7XP6MsaXY=;
 h=From:To:Cc:Subject:Date:From;
 b=rxf8Px/sRI8aDXXpPLhlzWA7uWbh8KlGWQty8kES5RT+P2cE0UZXEEk7kk3dpox6G
 4U3EzithdvlX5dCrUpSuB8HxmQk1UaHJEeMPlD9GBQxvV6kJhHp1/7vG5wwQFgAujZ
 8J2/JqrepCiN9l+GM1AFR4ph4XOMpfXEG9CaXA3eunj96pT3CF7kxt4gFWVmW49cI2
 yBQzPqBiSeQeLQ0bnDeJnllu9cv1Gd9xjYPac0pm7TEd3B3phZewlywDchtaA8Wmc2
 kyj4IPnK8suH6Z4FcqGxNK4kuoJegBuoeAE7HuJeTE+DUK0ijwELoh8zHTxKF51NPy
 ZZTcI9PosiYyg==
To: fstests@vger.kernel.org
Date: Wed,  5 Apr 2023 01:14:06 +0800
Message-id: <20230404171411.699655-1-zlang@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10670
 signatures=596816
Cc: brauner@kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
 ebiggers@google.com, amir73il@gmail.com, linux-unionfs@vger.kernel.org,
 anand.jain@oracle.com, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, fdmanana@suse.com, ocfs2-devel@oss.oracle.com,
 jack@suse.com, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [RFC PATCH 0/5] fstests specific MAINTAINERS file
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
From: Zorro Lang via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Zorro Lang <zlang@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: wphm-vLBNd-nKPH7qr3pVo6qK9YKw0GA
X-Proofpoint-ORIG-GUID: wphm-vLBNd-nKPH7qr3pVo6qK9YKw0GA
X-Mailman-Approved-At: Tue, 04 Apr 2023 17:24:27 +0000
Reporting-Meta:
 AAHN4KXMV13dSygqZL2ZDrbn0Cgn3tJhTfhfJnlmSXUrd3JU6LNcaH5Aabu4YF5z
 IA0DsxOfAg1DNh5V2PRi2EHsanQJhSpJQaaH9DO7JT1R+ccrBpjeZpVeP+VR83IA
 z+jvJkAdlI4SJk5qLhXE5CevwfIwrod4/YjBVapQlRY1y0iyINMoEknH8jay8z5e
 1pPSjMqQeS93LzNKNLL4AL8QtAvPd17rxKbDBg9bWUR52nr02Tont68HfdvDW9Ik
 GvdedIh7i18ml7OwrvTQIml+Z05ViviYxpeUZ6Y+YRbGjAXbNMq6eKVg5zZOjBgz
 ZmGkps+RkGoMFEBGxEuIcL1pBTBT0mhmaqS1wu7oZFx6zYpRRTKd2UgUE+8GY4IU
 9vPYyvt32hKoGYxjTs73SMhtIHAZUqlgXXATWF0rygbYQRupXMHBw26BR7CBNxGM
 cqjNtQvcflNZH1l4qnMY/+zdQ+q+f1E99erIg2tyEOlCDKbKrsnCWROQziHDdwSg
 Q1BUkPBaXi4NO1er6zhDiMZ/plyGQ7AKPkxExVxWXYhXjQ==

I think I might be mad to include that many mailing lists in this patchset...

As I explained in [PATCH 1/5], fstests covers more and more fs testing
thing, so we always get help from fs specific mailing list, due to they
learn about their features and bugs more. Besides that, some folks help
to review patches (relevant with them) more often. So I'd like to bring
in the similar way of linux/MAINTAINERS, records fs relevant mailing lists,
reviewers or supporters (or call co-maintainers). To recognize the
contribution from them, and help more users to know who or what mailing list
can be added in CC list of a patch.

(The MAINTAINERS and get_maintainer.pl are copied from linux project,
then I made some changes for fstests specially.)

PATCH 3~5 are still under reviewing, hasn't been decided...

About [3/5], if someone mailing list doesn't want to be in cc list of related
fstests patch, please clarify, I'll remove.

About [4/5], if someone people doesn't want to be CCed, tell me, I'll remove.

About [5/5], need more reviewing from btrfs list.

If others fs which *always send patches to fstests@* and *hope to have a specific
co-maintainer* who can help more on your patches (to fststs) before merging, refer
to [5/5].

Thanks,
Zorro

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
