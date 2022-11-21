Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CDF2C47090
	for <ocfs2-devel@archiver.kernel.org>; Sat, 26 Nov 2022 18:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Z+VCB3QK/HY7ddqrYmyz3rCbIPuqwtaKhaiw6QFS2Yk=;
 b=FN3tLUESDsp+2/f+jnImbeZUdKLlTBue+b5g3//NNEu3VBCMBt9FrpV8i3dZoDKj4jtDNEu1tXZT
   HzXsVqvlpXEaAfvY/z2o8tvxyuChsZr25qzWpEMyJV6OgN4s0XfhbGxDgwuybNNa/aK29/mdqicL
   FeabqcoSIHzWve4mpzoCgelu/R53gcrjKf4fiDZdZcgLFDzQB04sSOLPiDrLWHdi9xtmtuFkpiEx
   RwihNCj4YvEGVfWAxmunbipq0SCwNLqMvK5K8PZ3QGXY8T5mer3JJOOkrAVTp2oD00bE57zO+pCT
   RTEn7mZ0eADQR5G2DSGMArhm+xDIzAbN89/aZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Z+VCB3QK/HY7ddqrYmyz3rCbIPuqwtaKhaiw6QFS2Yk=;
 b=JQPPQX5+V91dJrYeig7ChXbT5eFGf3UgyBKi+r1RNdLmSvX9/YVNVundgiFroYuw/ognmhWFQJPV
   KR2KxjaK6iwb8CFzJzVtelmZTU/cghUsAQHJZMgw0Y9hwBC624qMsX+sTNUOslPPa3ZeoXtgp2sV
   8XUVzhMddX9B3lI5QPU3eQtEcO8IT2u69RXJhBSOMPgUAkX5UpYOe8BZAETu6QVyecUPO3JiiH7U
   UFzJqJMnY8oTygEY494lN5FyTMQyXofpJNv27jvez7TyKDT3SAreqgFcKTJk67bxGq/UJmguKesD
   /+XiBcF43SZQYhEwwz58PUgG7x0TC/hmO/RhtQ==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLY00M3VVYZW340@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 26 Nov 2022 18:13:47 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=sFqoA3xlAXzNwNaJLAB412Ok7P7Z69MnqdPRYsS/dcY=;
 b=UGMGIxl4MlQMRNDDoJWW1JeWd1Saa+VY7wYO0h5+ALzBmXWpD2TS+rloS5mLWItbTu
 dmLO6NI0/V1oHyb1t8W3cmApDUm4Tye2vUImDyToVFtk3M6GOw5Inchh/UMvHT2e/+Mq
 TZ0Zu/FXa04YRFFPQkZkOCpTQLS0EdUOIT0pN4L3oxkVk6sF6dYFnXSdIODc7wwURPgb
 9uoLDRbPa4Hxw+5ALlkY5tWI5ZiDCeNk3+/eGSw7eJ37LD7LmjdzmNfuwXTxMuQBy69L
 SQx4AJf0J8sU68MUvZMsMSHdQOZmK/LoNgQ2SeuUcyj1Hy7Nep6MNCRwXKjnXY74GtT0 A1eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id :reply-to;
 bh=sFqoA3xlAXzNwNaJLAB412Ok7P7Z69MnqdPRYsS/dcY=;
 b=QSVzz9DkFrF9vjzmgRwhRV2UOlH/WvOp7honp8fKtnbKjeUf4p5CoA6z3rOFNu/U3Q
 LN6SIPEErWbbbRjLSDiZ17jW8vMsJd+5aFg/ElEiYfUxRDbiSFZpaUcJIq/mnLcuKVHZ
 1STPOxmgg6FQ+A/mloYJxmL6H/1fizJsmBTuukl/Sde7UAtlxD43Z1y9Kdd1jzdwb5fX
 zj3h1csKzRCOU95yMHGcZU3TVczfkyyrybxtA4bLC9mkGlHJxFSlKtBF68dXmqbNncTI
 B4dr4ixnJA3WW7Z+3x6ELJoQr+nwm+gHBznbuR5Vx6in4hhj8W0VfA+ccQHELkzJSSMu uotg==
X-Gm-Message-State: ANoB5pkc3rNHSnIeN5lev05sfPGIYy7PImQZZRfeh/OMV4UDK5OtMZsH
 IRkgWB95hJYePfJBiBAG5EZsfEo0L2D8XGDmduDe
X-Received: by 2002:a62:2941:0:b0:573:6a8d:dd15 with SMTP id
 p62-20020a622941000000b005736a8ddd15mr11936805pfp.2.1669074971136; Mon,
 21 Nov 2022 15:56:11 -0800 (PST)
MIME-version: 1.0
References: <20221110094639.3086409-1-roberto.sassu@huaweicloud.com>
 <20221110094639.3086409-3-roberto.sassu@huaweicloud.com>
 <3dc4f389ead98972cb7d09ef285a0065decb0ad0.camel@linux.ibm.com>
 <aa5fa8c5f231115c58012352124df57d16a01e41.camel@huaweicloud.com>
 <7812899531b2bd936b25fde8fc2f1c2a6080b2bd.camel@linux.ibm.com>
In-reply-to: <7812899531b2bd936b25fde8fc2f1c2a6080b2bd.camel@linux.ibm.com>
Date: Mon, 21 Nov 2022 18:55:59 -0500
Message-id: <CAHC9VhTvcgOjXAH51Vnk66kEjXfjUS2aJjXjJmU-rwLT53vWPw@mail.gmail.com>
To: Mimi Zohar <zohar@linux.ibm.com>
X-Source-IP: 209.85.215.176
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10538
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=176
 impostorscore=0 malwarescore=0 suspectscore=0 mlxlogscore=969 mlxscore=0
 adultscore=0 spamscore=0 bulkscore=0 priorityscore=115 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210177
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, dmitry.kasatkin@gmail.com,
 stephen.smalley.work@gmail.com, Roberto Sassu <roberto.sassu@huawei.com>,
 jmorris@namei.org, reiserfs-devel@vger.kernel.org,
 linux-security-module@vger.kernel.org,
 Roberto Sassu <roberto.sassu@huaweicloud.com>, ocfs2-devel@oss.oracle.com,
 casey@schaufler-ca.com, eparis@parisplace.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, serge@hallyn.com
Subject: Re: [Ocfs2-devel] [PATCH v4 2/5] security: Rewrite
	security_old_inode_init_security()
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
From: Paul Moore via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Paul Moore <paul@paul-moore.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AA0mqf7G6c3Nvud9YG/dWkDyX6JZDp8dvZSG4MT1APz5NyskblXGRN/R4W65HJ2mSLW6V+5KIth5yCSQDFWO6JKT7SI=
X-ServerName: mail-pg1-f176.google.com
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: 7InMRct0TnV5bmZ_BeW74a62ytLk2ELT
X-Proofpoint-ORIG-GUID: 7InMRct0TnV5bmZ_BeW74a62ytLk2ELT
X-Mailman-Approved-At: Sat, 26 Nov 2022 18:13:43 +0000
Reporting-Meta:
 AAGqeO/AGCny1lv+cfcfL74Li3lrEd194GZb0YkcysSllppFQ3d17O5s1fl8DStF
 05clvR7euLLlxIim2O3xv/syP9jPk0zdfqLFc2n1Wl/aSM4CeHsxZjuv8FKpXjnv
 IvwCWAajPBsuaQRcw/G9mPpvh3HL/aLj/wAD06XZ5W98JOaWdvQ+i7EMmOrJchOZ
 t0n1ZWynzXwr2KBnkmW+kvr5uXrc70DfPn0l5vuOqUHMRgqbTw4Y12qaqXjOyJfJ
 5Cf5sbuZMO2dohFG4SpSy5/fGSpMacjE5owH6qKpC/SiQecHwntm74lkZRP2yCGY
 WS0wQfyLNU/dIiNA6bbDcwh25jZVFa8IdZ+uc6DPImha9WmeDyQLSyx8IT+xz9PZ
 rZtLTmoPa6fuRoLyyUlkpwsfqrm63taMgv/MGKzsLYIWgKoh3Nqj+k6XD1BdRM3Z
 qkiKTyAP6UHWvrz/gyv9Dm51+JuQjT2El1MTkzgxZYGVWPWUqiXE5wSvPNuXlRaU
 Ykl35pTGz6gzJQl0Shc2PfHkXZ5RXV74FdEGyxtucqol

On Mon, Nov 21, 2022 at 3:54 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
>
> On Mon, 2022-11-21 at 10:45 +0100, Roberto Sassu wrote:
> > > As ocfs2 already defines initxattrs, that leaves only reiserfs missing
> > > initxattrs().  A better, cleaner solution would be to define one.
> >
> > If I understood why security_old_inode_init_security() is called
> > instead of security_inode_init_security(), the reason seems that the
> > filesystem code uses the length of the obtained xattr to make some
> > calculations (e.g. reserve space). The xattr is written at a later
> > time.
> >
> > Since for reiserfs there is a plan to deprecate it, it probably
> > wouldn't be worth to support the creation of multiple xattrs. I would
> > define a callback to take the first xattr and make a copy, so that
> > calling security_inode_init_security() + reiserfs_initxattrs() is
> > equivalent to calling security_old_inode_init_security().

FWIW, reiserfs isn't going to be removed until 2025, I'm hopeful we
can remove the IMA/EVM special cases before then :)

> > But then, this is what anyway I was doing with the
> > security_initxattrs() callback, for all callers of security_old_inode_i
> > nit_security().
> >
> > Also, security_old_inode_init_security() is exported to kernel modules.
> > Maybe, it is used somewhere. So, unless we plan to remove it
> > completely, it should be probably be fixed to avoid multiple LSMs
> > successfully setting an xattr, and losing the memory of all except the
> > last (which this patch fixes by calling security_inode_init_security()).

I would much rather remove security_old_inode_init_security() then
worry about what out-of-tree modules might be using it.  Hopefully we
can resolve the ocfs2 usage and get ocfs2 exclusively on the new hook
without too much trouble, which means all we have left is reiserfs ...
how difficult would you expect the conversion to be for reiserfs?

> > If there is still the preference, I will implement the reiserfs
> > callback and make a fix for security_old_inode_init_security().
>
> There's no sense in doing both, as the purpose of defining a reiserfs
> initxattrs function was to clean up this code making it more readable.
>
> Mimi

-- 
paul-moore.com

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
