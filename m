Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C89E1C761A6
	for <ocfs2-devel@archiver.kernel.org>; Thu,  6 Apr 2023 14:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=kEkTgrH9s6xu+7g0Lu0a6LVmofHB2R9BGuDrg55Qeoo=;
 b=IjG6z+8MRPtMdLfEm/8kWya2xGKS4HQblMnOFlksIfJ6oupBa9VjkrFuJBgGPR/gJCvuSHYjmWbP
   6jHSdvRKW9rOBC4R6NHY0OaGdyU60s1qWgC6uGfczNOery6LZfMik3q5WL4RGdhGuQmeDFY8e0dF
   Opl5rdW9LPxn4JYlHHqoFUImqcc2IVhZEbfLnRFEZEB0MP1yUdK9d9jT0jaMGLxwaypM8tA7kvGf
   dHdeauzReOg+jUc3ZBfMvfqwUDIfUi4YMluesdAm/uLwiVf/N8HvkM3hsEKRKgt+tVJVUf+7Mr2W
   Imf6Ries4Nxi7DcoiWRUFqAp31Q/B6WMlflMYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=kEkTgrH9s6xu+7g0Lu0a6LVmofHB2R9BGuDrg55Qeoo=;
 b=NeP6buumwYrQKxyaL4czERdfQEfnzMxK0YRjD/EwUFmImDGm/Tco9xE4rCoJVqgcrXlQVTnP/lyT
   AWLdxFnUQexUx14GCe7vNxoVafC9z8uuQnTyWBET8i0fkwb5Ih7HNBpniK9O9sz7k//hZDSXZvy9
   spjm9Dihiut7qLKunogzitU0F5O/IyeqyutpKKFzDURGM7IeCIdXJfi4q4+g47g/FPxk85xGGrjz
   ZGTbdVwGwaVZv5Xm6YVVWbJ/cV7KDp+L5yDhDG6NHny+6JYSJl188rGaa77OHeXegNE42WoviqDN
   qJqpzz+7xWIFZKGR5CFoi240wbIrVzGoWEw3gw==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSP004X16DQAC10@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 06 Apr 2023 14:17:50 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1680790652;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=XIwFAYmq+ddhYZF0Zfe4K0b1+UJuE82HHInNFEctczc=;
 b=ZeJlivpALd8nO/1+mor0TCnnNBCMsJ16FUvMbjtBENF8lESP30O3UQN0FbK8ak1vh1Omwl
 9TT+BNH6w2K4aPeYip1Ds2fvoITG3Q8Fm+KvriE04i9alnRCUvhm69FhfCLv5mocbumPb1
 0G+YcC5Y0BrrKYEE3HWcPauZDd0rLVE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1680790652;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=XIwFAYmq+ddhYZF0Zfe4K0b1+UJuE82HHInNFEctczc=;
 b=57+ei+nga6/9LWL0dAtibPJpgEe7tVSlAh13SWgoLWDg91xKuwog3XYPUrzIaZgUJ974ZK
 mnJ0Dn3Ki8c7xoBQ==
Date: Thu, 6 Apr 2023 16:17:29 +0200
To: Zorro Lang <zlang@kernel.org>
Message-id: <20230406141729.GP19619@twin.jikos.cz>
References: <20230404171411.699655-1-zlang@kernel.org>
 <20230404171411.699655-6-zlang@kernel.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230404171411.699655-6-zlang@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10672
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 impostorscore=0
 bulkscore=0 suspectscore=0 priorityscore=90 adultscore=0 clxscore=121
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304060125
Cc: brauner@kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
 ebiggers@google.com, amir73il@gmail.com, linux-unionfs@vger.kernel.org,
 fstests@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, fdmanana@suse.com, ocfs2-devel@oss.oracle.com,
 jack@suse.com, linux-fsdevel@vger.kernel.org, anand.jain@oracle.com,
 ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 5/5] fstests/MAINTAINERS: add a co-maintainer
 for btrfs testing part
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
From: David Sterba via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: dsterba@suse.cz
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
X-Proofpoint-GUID: 0FoLCXV5HW_PbTp0eIo1lAdpkekVxIQX
X-Proofpoint-ORIG-GUID: 0FoLCXV5HW_PbTp0eIo1lAdpkekVxIQX
Reporting-Meta:
 AAEWxExV1T5Kq6YPN+KCAx8rkfntEyzAiKjcH72IHLt2w/exhI9PTmxFa3W/yUXW
 ITPyxIYKXhXrGjxTtdKy31AxwjG2hTcAl3MZbkNBwLjKBYHJ5bt8lMqR566fsZEO
 jzCgKarVPRJJyemNWgcuKk3F4FresP9ZmfQtUYgxhSarmLZZm/f83KCDTbylyxNj
 TptUb4e8dCkN85CeZpaPZIgjo3lKOzzQJreLZT/zj+D/RtrYWMGJrFVKTfOfH93S
 oWj/r2m+Se+RScd8EcuNjCIe+M1rigLP0aLxhaZVGnRq4LzskjrsG1D9Oo0hs1wx
 oqdO4k6dQ/GShI/RM6yA4sDem3/aByrBHj6la/QIm156+wHqgW1aIcuSceBxpZNO
 fGnCWbYQ7tTm7TK1qk1uGnZe6qIbkzcYAwWlvo3eoXauMnJCfydPVOoL+SNStpXN
 +JaDjNdyuQBY84eHe1+MKQz6F76r+uAtqQROTvh494zSzg+nxuFJ5l5PY5QngNh1
 0k6l2877t1J6dqwuOUJaBgEtAKcJZ6Krf+AfK0yU6yLiNQ==

On Wed, Apr 05, 2023 at 01:14:11AM +0800, Zorro Lang wrote:
> Darrick J. Wong would like to nominate Anand Jain to help more on
> btrfs testing part (tests/btrfs and common/btrfs). He would like to
> be a co-maintainer of btrfs part, will help to review and test
> fstests btrfs related patches, and I might merge from him if there's
> big patchset. So CC him besides send to fstests@ list, when you have
> a btrfs fstests patch.
> 
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
> 
> Please btrfs list help to review this change, if you agree (or no objection),
> then I'll push this change.
> 
> A co-maintainer will do:
> 1) Review patches are related with him.
> 2) Merge and test patches in his local git repo, and give the patch an ACK.
> 3) Maintainer will trust the ack from co-maintainer more (might merge directly).
> 4) Maintainer might merge from co-maintainer when he has a big patchset wait for
>    merging.
> 
> Thanks,
> Zorro
> 
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0ad12a38..9fc6c6b5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -108,6 +108,7 @@ Maintainers List
>  	  or reviewer or co-maintainer can be in cc list.
>  
>  BTRFS
> +M:	Anand Jain <anand.jain@oracle.com>

Acked-by: David Sterba <dsterba@suse.com>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
