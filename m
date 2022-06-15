Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 312C4C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 15 Jun 2022 08:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8ldIX0ab+MhBSRsojg4UrmfSMyCYSRHFYmBTMsEpJFQ=;
 b=RUCBaDe/jjG8c1gDDSx1uQcgD1Y1CmeVoZF0Zp3HgamZxOu7PFh/IUWCPFzFU35lfKUA4nO0yaNv
   YzvXRwffN2MbwA8MzTWcI06goyD1ujIZaG65FAADPTa/6GNLP89HsE/gxn41b+c7qmBtjWR2cTy4
   A6l4ca3fwXgOP66kROGC+2mIxDOp2hrZttCKfzcQFyrKfsK1CYu+lxvPfS5zeOX/TnM6rGDk2xKQ
   5meiSIDBQFM6UPXWGJ61zSN0vx3WQzB5CZ6bzwMTX53JJUo7rk+Pdmq45+WbYXkuvkTUp4S6aOJV
   XL15DrqdBM51JA8rkJgk2q/3kXc8a6VxwssFRg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8ldIX0ab+MhBSRsojg4UrmfSMyCYSRHFYmBTMsEpJFQ=;
 b=h7xPJuNXDqbEWSMogLnFdYm7c/Rkm+1k5ezqkb4Lg6XC7ouDlowfuFYJFmcEG9bFygoePIVb/BVU
   6FnVzeJCVWSugoAJPwzqpde5cOFOyHNucBS29+VHJ33Q/+muO3ijfAN6taX066LnmP+omoKbPKyp
   H4v7fV9Xr9z9hoIrvO1mZhY/RpVF2OnGfxZSySvFLN6YkHeDUIRZPAMWwz4koO/Kyy6suPpP1Dp2
   URGXoj4rZpO3TExf0FWXG7W7hs0lAAOpbKm4w883KYsDJ3mRXTTgjG3L3Uip8t2+Ktg8Bv4T7IO0
   LC4xE03ejn1GKYi4OJr1o6ZE1mcWw0FzDzgjcw==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220531 64bit (built May 31
 2022))
 with ESMTPS id <0RDI00MQFERZ5R70@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 15 Jun 2022 08:11:59 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1655280703; bh=G8h+IDpJR0CvhZVQBHmA8xXUGMUALrZIeamkPUOOwAc=;
 h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
 b=J6Y3XOcwoC/TgUHQEi+SmCxARb6tPwZNqAYZg5XUTUI3Q/ll5OApOdFtKbROVKu0J
 G3wBk9/2zrpVCGzGGdhz1ESbgkoh73YGsKSRIOJUxvsHV+/K5Zd6avT4WMepRjY9H4
 wamp6FUhQPTuGWEhQiYvx6IJuRvj3n1pbZp2ZHUm41s47toXZ4TP69nqNoX31VqQXs
 PJkwswu6LBuH667SA02KF13mHrfORzWm/2zDlI2HgW90bjJCTh4CmOq+CyWlVyareR
 TNZ8wmpjenOnCxxJfBdf7GMJYbuk/uABYuIiv48owX1ckCCiZaFExYBEBPHV4h2PdO
 DbPuKfjHUQGOA==
Message-id: <5fdec03e-efb6-554b-55b3-49e7e7f2be5e@kernel.org>
Date: Wed, 15 Jun 2022 16:11:36 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-language: en-US
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org
References: <20220608150249.3033815-1-willy@infradead.org>
 <20220608150249.3033815-15-willy@infradead.org>
In-reply-to: <20220608150249.3033815-15-willy@infradead.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10378
 signatures=594849
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
 linux-mm@kvack.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [f2fs-dev] [PATCH v2 14/19] f2fs: Convert to
 filemap_migrate_folio()
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
From: Chao Yu via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Chao Yu <chao@kernel.org>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-ORIG-GUID: Gp-CjdghIUe4cmSrOYWA3LVAoSOXXLkS
X-Proofpoint-GUID: Gp-CjdghIUe4cmSrOYWA3LVAoSOXXLkS
Reporting-Meta:
 AAGiZS9FMcQUKShRmVKDtp1TPzvPej+9jga1Y5Cg7WVfe/pqtwV9HIjRWjmELRl6
 6Q4lURa65Wz2TpOGCAdd1ZBxUJ2EWlClQaoSkqxBXX2CjD94JOLcQCixeCvvi4St
 9JOGl3P8dojOL8AaMfHwffUzmEK2sgbw24g2rk6ZgBYrEw7xTJ1FepI3HhEcynqO
 T37pM/GYhXxlO2urIsSaHpaJ8Ht1Fubq1qKJuJD7P6mtmeKjRXC60R5CgOwped1i
 R137ugn5c74qmVsO5SwfC/NZdkJWrHJpa7LUTT1dfoFEGk3VlzQn+22FQvi/20/l
 EzDhP5OKVsnluUZrV7zxlMAKwe58PWHXSW8X8u7g618+NS+PL6Mku5TAWkNhvmcR
 kRCLe/YNrVkiF3yrRCooDi+aiQXbABAWKTXgDF69iSzaQcB8GhHmqivUn25Z2E4O
 1hIB+BpIj2eVzU/gUPHqwvII/c5dVdnCcqPYBFFVnQjDZ29o2ICx58KcND/2ntXW
 VLmoi8j76pkdSuZL+7EU5JqafG/sLkQfFd3m/XiyYX79

On 2022/6/8 23:02, Matthew Wilcox (Oracle) wrote:
> filemap_migrate_folio() fits f2fs's needs perfectly.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Acked-by: Chao Yu <chao@kernel.org>

Thanks,

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
