Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 410BAC6FD1D
	for <ocfs2-devel@archiver.kernel.org>; Tue,  4 Apr 2023 22:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RCXKPP4ANJjok00y5y+gKMpHxj529UNyp1xze0rHf1U=;
 b=Vh9ykLIF3hG5oyxG47bF1yvz38qbvsxUNytStrswTvO45F47+Wn0HWoT2pH0w4vBbcpCOVmvJnVO
   0+SO3miQbmCnLQnLl/aSY6aNRs6Iqzl4Vo66NXzU8hLApAW0KBBKUypolxNmfF1aGLm9bD5gGk5b
   UfyxoEZ9AanVMW5k1P4zOJ6UbakQnAtRBhHiGtTCu1vDhzzYOoRrx/KQ0zM2i21D6GJSKCM/zsA2
   O2rV1GtR5enpIrEjC73u00Vfi1iuc+hZxCr3dSNVst+zpmdRkDR1Synb88GBCeNLF7HAKjrk+euO
   ueHGHwi3pLILJeeU7rrkUGeJ7U5SASmlevocJw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RCXKPP4ANJjok00y5y+gKMpHxj529UNyp1xze0rHf1U=;
 b=fCf/Ye8RmE5Q36IjpMUvGhJE3xu50okOlJ7t0OWrG65bm2MHBZGdlN6lqT/2ktFXvbaFXuST6hRc
   fRT/GufwghsZnNab8mU+IIu0M+WkzBdg1QFbIz0K+W6kZHOW58CXOnb8FWCPXk+1JsSVT27iDbI7
   KnS3jlzwabqYgPzekBw7f3YeJNjUcdGuzgv3TZ7aoyxF0Anjcgon/wh89Bhwdmhryoi+ZDwYe3FH
   49HbG5shaX2gBDxHOpFaZQkIwt3TIF+f0QGell0etJL3Z6usC/xVJJe37jLA9BEwYUo9xTalcEn3
   fE3qThge1QBecetSbzeK4PqrnyT0QUJ5LCO/dw==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSM001UP38KPF00@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 04 Apr 2023 22:17:08 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1680646615; bh=iq/IdV4ogpOzaM8KgGTnYC5Td3WCpb/PqmrSUjFcqq0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=hKIBSlBctkP5bivjN4Y21mckkcqW66+dkJqVt3sV5xlPSN1yzxtbcIDAa/udoQiUM
 sYGbOLNwfOA0gXRR+Wndw2VsarlhINwbmR9rKVH1FeHvdejvWrBskWjfnQnco9YqvD
 rpI3rk+9EzaMTkMEFIRuzDVL9UMVtvyfJBQ1f5Ze4NeqUuke7n1BCeowZBAWgMngKo
 42ZuMczWbvBA3Owwg/N+nslkw274BP30Pj/y3YKUBj/353slDtMf8ZPciuUUqEM6Ip
 0wa3X6hCp3Y9aaK3d1yKPuqKpW2wz0WLI7SD2d8mkTPKHHanh741qLv7i4NdaAMa8g
 +Pz1NY60vkAcQ==
Date: Tue, 4 Apr 2023 15:16:53 -0700
To: Zorro Lang <zlang@kernel.org>
Message-id: <20230404221653.GC1893@sol.localdomain>
References: <20230404171411.699655-1-zlang@kernel.org>
 <20230404171411.699655-4-zlang@kernel.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230404171411.699655-4-zlang@kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10670
 signatures=596816
Cc: linux-cifs@vger.kernel.org, brauner@kernel.org, linux-ext4@vger.kernel.org,
 amir73il@gmail.com, linux-nfs@vger.kernel.org, fstests@vger.kernel.org,
 linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 anand.jain@oracle.com, jack@suse.com, fdmanana@suse.com,
 ceph-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 3/5] fstests/MAINTAINERS: add supported
	mailing list
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
From: Eric Biggers via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Eric Biggers <ebiggers@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: ImYlG-YXYrC58AH6JueVoZmAmUuefBf0
X-Proofpoint-ORIG-GUID: ImYlG-YXYrC58AH6JueVoZmAmUuefBf0
Reporting-Meta:
 AAF2DmucJ31tp1h5yp1GAjmpq3rmcNF4d201GZMuwHMObJEMxyKU4+vP/ND+RBXv
 OBeFKvHtumsGBhoAXZJmNedKgA3m4yF3ntCF5M2mGFyie+oYCwxqugru/nlXul+P
 V2RAgokq+EFzcqepBgW4EIvozEjN/uSj5TcpWYC5Wrc6h2CLOnUy0KQkf2j0hxTn
 wtCpIEy5X7EAzi+UP9vz0pNz5rbj1N3akwLZVFdEoAvUqeHY+mr1saBgeOpSdq+n
 ce3ICD81DtwULdqygC2I8AkkrkepuEZrEUs8/v/Vbov5TeNSubIhemGJQg/zPaxt
 dBZHzvW1AuRQ/Sm/r5ZHSP0qkb9n0DbxF9fJVhFN/nyFEYivw4KS3tXtXkn3THFT
 ZeknsjqF09bqK/CYI2cVuzUxwitcEPOizGOe6VU/ZvbZw2Z3jdBXAWlEEskpPhnu
 eJiS+OaWYDDYWtZ/LU8DAGkoNkdsjDgh8oR2I3L3efdSi9rvY8BXGnJthapgj1oh
 QigZfqAg/2UYpe6LhDIOphqv5C12TigFpk4jjmrK10W6

Hi Zorro,

On Wed, Apr 05, 2023 at 01:14:09AM +0800, Zorro Lang wrote:
> +FSVERITY
> +L:	fsverity@lists.linux.dev
> +S:	Supported
> +F:	common/verity
> +
> +FSCRYPT
> +L:      linux-fscrypt@vger.kernel.org
> +S:	Supported
> +F:	common/encrypt

Most of the encrypt and verity tests are in tests/generic/ and are in the
'encrypt' or 'verity' test groups.

These file patterns only pick up the common files, not the actual tests.

Have you considered adding a way to specify maintainers for a test group?
Something like:

    G:      encrypt

and

    G:      verity

- Eric

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
