Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 158A3C64ED6
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Feb 2023 12:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=naLS7rm28nmdv2RAd+5p+YbBx9xJaleX3vdMJ+0PM2A=;
 b=cbNYqOpBGQOcKluk+g/xNpVd/VXJSW1XQO0n3nVRPrk7HcP/CxP9ez0wOIFoB/oi58x7VrO8hCYK
   AuxPY0MwU070+cM6hzQE2FAEFrPoycvPw91l1oIbEtaFkXbP6mQNMMRVmaG3Im08WZmhdllz+Ox0
   9MvluDv5sw18bnDpyfgca+ju8M5uSJf6DaBE5b5WJFT62uy1MR7L2VYXaYT7vwQZ915JqwSm7dvh
   x31FFSzeFU4feRB0YSjqYextaYwo/ldjgVrfJfU7Il6IV0z6CN/AJ3+eSs+9rqAY31j7GKhMiwFj
   Vp4OuEJt7euqoeSkysEeK2zmlbBAGumIzVPsVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=naLS7rm28nmdv2RAd+5p+YbBx9xJaleX3vdMJ+0PM2A=;
 b=X4ZO9AsARi9BA1xxPGZW5ZNbagFhCKSxM7sAI/sdg6FVaZgP5uHI2W28L6s1KEpwHMvZGsoEaSgi
   Ey1xq/YZPNq8jxFVu6Oi2hJKwMxNZxnd5Dyu8EFoJa6DTBBRg7YtxHadubGl7nYi24WgUxY4yxUB
   nHBfIxg8yFlUJpzz9XyAY3hYuZj1m6Xxb1wRNQx6calCFaoHo4v+CmnYtp/4sDpmtg21R+gWZ0Sy
   E+KdyEPULqgmIfWSpb/ICBEax3JRqPi7Xe+4gFK/zsECkCDjfIphGRkJ329zpxIr5IgItLzGpQIt
   4nqwyW+Vk+MHnvkmIWYH1TNjPZx7s35G1XPdxg==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RQS00760K3M2OB0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 28 Feb 2023 12:59:46 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1677589172;
 h=content-transfer-encoding:mime-version:date:message-id:subject
 :references:in-reply-to:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to; bh=KXJtA17sEPdxzjGQRqo5/JFvtFde4VQEEjSMt1+MlDY=;
 b=mDyvWPGkbF3bJHaDb6URbCMeqSru6ugFNy/bIXh2NNi/ioO3zW+ma+AR2j2IwC3keR
 UoLtO2v1uvVynGfnjuYmbACZ4C4Uhv8Vmo/e7s4m8DazX56/y3yVJynMx8mD/W0mxqCK
 NzBY54eZADgur4Rkn0MoQR1vXrgH3RGUBiOoFknvp+uxjZaXYhxTYtZP8z8loYtrsZ1X
 YxTgT0KDf2+Qxo9j8WUArhqNLOhYUYSbLQZsIPgbaja4UfRavwt8/YAU8Qk66iWIoY5o
 zvyUZcHnZZdZdrPROyDNovpgFjNyZ/SQUXn8i15WFP4TafbtslEV7XyhcSCKR34oY1Ip YIaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; t=1677589172;
 h=content-transfer-encoding:mime-version:date:message-id:subject
 :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=KXJtA17sEPdxzjGQRqo5/JFvtFde4VQEEjSMt1+MlDY=;
 b=TIHmhI+IBGnIgopxZ7BNDFOJKeLyPjlaZ6x9jU095MWL+qZQ2Vonr6jM+tZK0lLfK3
 iJYln8aoAsCYueqv0ZQaEqCO5aCa+IcTKwljRQ+j/phnwesyNpckDrmcY5YyU10agvd9
 FG8/sZdzl/JtQzno6FoDE8+GBf0jNIcmv7kBjrRKhMbgDNHHjDDhu8jgMfzquKILoZ8e
 d+Er0LqQT3+f9Pl3WqS5431a3J4oir6kxXztC9b0nmOew3J2uNkbI3B31b3UCZ6MUYHe
 MGXmUN/qYhkWKWKoHIEcvsPO2Cc765PGfWCOCzD5Yo0QneqEoPhx67ZpFI6Smy5zSLs0 zmtw==
X-Gm-Message-State: AO0yUKUcJqvDkgtLA96ydjUw9ZeroVKXdbzfnqzRdNeXIiqUJ/ans2F1
 FsrzHh8tcvXO7Ghlzb6IJ9OhWw==
X-Received: by 2002:a17:902:e543:b0:19a:9269:7d1 with SMTP id
 n3-20020a170902e54300b0019a926907d1mr2964175plf.4.1677589172564; Tue,
 28 Feb 2023 04:59:32 -0800 (PST)
To: Joseph Qi <joseph.qi@linux.alibaba.com>
In-reply-to: <20230228045459.13524-1-joseph.qi@linux.alibaba.com>
References: <20230228045459.13524-1-joseph.qi@linux.alibaba.com>
Message-id: <167758917178.12826.13481934362166793957.b4-ty@kernel.dk>
Date: Tue, 28 Feb 2023 05:59:31 -0700
MIME-version: 1.0
X-Mailer: b4 0.13-dev-ebd05
X-Source-IP: 209.85.214.172
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10634
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 adultscore=0 clxscore=177 phishscore=0 malwarescore=0 priorityscore=138
 mlxlogscore=735 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302280102
Cc: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
 io-uring@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] io_uring: fix fget leak when fs don't
 support nowait buffered read
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
From: Jens Axboe via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Jens Axboe <axboe@kernel.dk>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AK7set+Wesvq4ADKotBrhahVOK590hMee6o5LDqTctqAO+LO8D8tJEOkzucm4oPjIFohMcBEa+MLfQ==
X-ServerName: mail-pl1-f172.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: MdHRxW9gH5ADLIe3jiXBk6mXoqxCw4u2
X-Proofpoint-ORIG-GUID: MdHRxW9gH5ADLIe3jiXBk6mXoqxCw4u2
Reporting-Meta:
 AAGaye2LzKvKmzouFVtQGag8K9gweJmIO8Gk+nTJ5otw+7O0qlKqITJkZO4uaDsC
 oLgj8oXUojdgYYnO+gGBvBHPjY5LlWQmUPm5InX6eky8tv66GeqM01oQHI7kJTfz
 /MLupJz1UK81J7oZWU8IIOVr7tWRBQVomdX0LpUKLmWoqaYPQ8AFGh1YNbb0b0oR
 gttmCw3d+jDmafrxXtPgCdHeVWoTHPIC+OGX9e4QsHJxq2jxXs1gpfnQgBkQjxH1
 WR9c7DulZzTyOn0uqNa3COh/8OunNzkuWqEhpDbTqzdyGkPk3Ve3WcWCcBaueBvD
 0SiUd1hayaGbGE3TM4NwR9cDDS8SI9I1sVeNDmw/lw/MDC9JHOu0CFmnBIR9kLD6
 913OmvolhL1Mvd0VlsnoIwRNx0l417SCD6Ztb9gyxKVLSPPtOwAGISZtJJJ+XWa9
 KLXNKjR4UwHMG68YIwOG9DwukYvG7DDfwHRXS7KrwDWBFeisMW/ymHHWPwnO1Lo5
 FvPu8378gW4NsvQIcjR/J6TUKXNqkBJJKrqeo73bHC7/


On Tue, 28 Feb 2023 12:54:59 +0800, Joseph Qi wrote:
> Heming reported a BUG when using io_uring doing link-cp on ocfs2. [1]
> 
> Do the following steps can reproduce this BUG:
> mount -t ocfs2 /dev/vdc /mnt/ocfs2
> cp testfile /mnt/ocfs2/
> ./link-cp /mnt/ocfs2/testfile /mnt/ocfs2/testfile.1
> umount /mnt/ocfs2
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix fget leak when fs don't support nowait buffered read
      commit: 54aa7f2330b82884f4a1afce0220add6e8312f8b

Best regards,
-- 
Jens Axboe




_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
