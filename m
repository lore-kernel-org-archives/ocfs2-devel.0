Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC103C6FA99
	for <ocfs2-devel@archiver.kernel.org>; Fri, 10 Mar 2023 03:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=w9uLTj0slDLlLwg3jTjx2xsD+T6JkK4IB610Lp79Auk=;
 b=TljMFpWoss+65O4vpKzqbSYRJt7pSqy6bhQsDikOxWTNBxsBOBTC0IjDzKaVqeGRbb6eOBfcnjVg
   MUE91ulR3o/kN5Z8w6KTHuzfWEGlLA5fuGs5g1T58y6Ei8LBN3tyW78GgiDnNyiilQ+EKhzvnPdR
   09xW9U4nbHmnRKWkSBOwgebds7rj4ynWpNtP2/3bvMuBGeo4i6oR7+tT+8iz/ZNibQ/m+V5ABzz3
   B86dQexCAF14NHDShrNfDNnoTgV8upqcxCvY2H7+S/tDpIl8LIVpD8uQPQre8/tSWhs/iKtusxPP
   S0SWrjubkpd9mGDsJpXABXCQxXoaAzMkDEZW0A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=w9uLTj0slDLlLwg3jTjx2xsD+T6JkK4IB610Lp79Auk=;
 b=tHciaKBp1Dr+E1qdTCuviyOiAp6iSVsG1zzWAcVULpeuDdC/NL5wWUQSKcLh1b0uvWjwIgcpyNlW
   r7Gpdy0Wew7D9Nn/EbTtPYe0PoF6B5UW5OLOHV+BuIB+ccv/2ed/atUcvk3u3Ae5/wKbnItrt1O2
   0SVaInBaoLLZDTivLgkDbVKvnqUsGWbJfQ0oGJM6VS3dCMK9F6OuCLzYs/nKDbahnCD2KlmyLOpm
   8C1xhqcT9zAuSv6Fcv3rMdDPg7bBj2ZZ8QC8/fZqLu9Jpxp0V9iUBnmsmhB3yq3fC9XKi3o5qPtD
   w59C5KKpXCJxjSZqmyYVVwoZLrVp7VSkZXRo0w==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRA00414BXQVH50@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 10 Mar 2023 03:20:14 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=9GsbB5b7BGtJnl9LtZ+ApF1Ae/mKzKhIP/UQI7rA/0I=; b=QxRSy9LlNWuDonXYa23yzhuHgy
 fCeVd5y8zr6e2px1BVDmNZ7RL0MVOj2WYo4ZriMLDOfoQ3eZR6enevaGtBQ+Ir4yBmpmXAX+9aL/j
 ni2GPsrAyhspoV8+YnhHKAoL7jYum3OgPXbydPXtzTvExVVrMO2OfUocxfBVnSX5eyUaBkwPkrCc/
 VE0M31dReAslqzUVi1nlmsHl0MbEIsFjQxu3dd29ddYr1m/sgOJlKeCEh+Ts4lrH7rnJYmJjPRTxJ
 4IxBaEIwaMXYrF8lhn5WVD4/oC9zxg9ep7OMmQz6A+Jst/zsjIbHd/4BSig2belxygPu+j8zO//Ur
 rrpmXtWQ==;
Date: Fri, 10 Mar 2023 03:19:40 +0000
To: Yangtao Li <frank.li@vivo.com>
Message-id: <20230310031940.GE3390869@ZenIV>
References: <20230309152127.41427-1-frank.li@vivo.com>
 <20230309152127.41427-4-frank.li@vivo.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230309152127.41427-4-frank.li@vivo.com>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10644
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 lowpriorityscore=0 clxscore=140 impostorscore=0 bulkscore=0 phishscore=0
 suspectscore=0 priorityscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100023
Cc: brauner@kernel.org, tytso@mit.edu, agruenba@redhat.com, chao@kernel.org,
 linux-kernel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 huyue2@coolpad.com, adilger.kernel@dilger.ca, jefflexu@linux.alibaba.com,
 linux-fsdevel@vger.kernel.org, xiang@kernel.org, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v3 4/6] ext4: convert to use i_blockmask()
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
From: Al Viro via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Al Viro <viro@zeniv.linux.org.uk>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: zeniv.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: IlJUsGOaHPkcxVhAAzKXsmofGqqnHH9i
X-Proofpoint-ORIG-GUID: IlJUsGOaHPkcxVhAAzKXsmofGqqnHH9i
Reporting-Meta:
 AAG0A57xnf5pkVZ7Uo+QZuXJ8KTQU1nPui2pwlWbJ5n7w6iQBx05vmL0w3XC2pwG
 HZ5aa0SvmKBLeVc0g+s9A29khvdbqui1d82AHXH+gyyg9anXYUmxpDG0prS32yIv
 pNltR/o9HKvz6clUtjJlwjN6K4866Vdy8WCH+fXotJL2K9Er5Y4ZNNG0EFlPiJ8l
 lamw7OFJV4o77teHSVL9ejsnUq+eaH4wUNDx/NyU0GGO+6+c0dcetNt2FR5S+zxV
 X+bYE17d7AvAVReF7TO3ZLcVjBgTReQoD3TLqSTvOF37IF7I1ilAsqYttbvPdJrm
 n4J++6rgnUEawR50CLWeIw7wnSX+Yt6A3w8BJwLwB8jaCY3W6WnEjYEXqTDwm0su
 S3Sm8WHf0S7guzcOhDSglfCTI8/EYv48XyYFx9mh4+qjuBZE+u6tCzQ5Vp3aC5KV
 nBqx9GyXK1UNcLyuzBeu3DZXWXH6nCTygWOY4fMNRONbKx2Kl6wHtcgWrePVFa28
 XpUXRR7OSfr+XXe4dLqbZOcbDBCT5aN0+AWIeMU09vEN

On Thu, Mar 09, 2023 at 11:21:25PM +0800, Yangtao Li wrote:
> Use i_blockmask() to simplify code.
> 
> Signed-off-by: Yangtao Li <frank.li@vivo.com>
> ---
> v3:
> -none
> v2:
> -convert to i_blockmask()
>  fs/ext4/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d251d705c276..eec36520e5e9 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2218,7 +2218,7 @@ static int mpage_process_page_bufs(struct mpage_da_data *mpd,
>  {
>  	struct inode *inode = mpd->inode;
>  	int err;
> -	ext4_lblk_t blocks = (i_size_read(inode) + i_blocksize(inode) - 1)
> +	ext4_lblk_t blocks = (i_size_read(inode) + i_blockmask(inode))
>  							>> inode->i_blkbits;

Umm...  That actually asks for DIV_ROUND_UP(i_size_read_inode(), i_blocksize(inode)) -
compiler should bloody well be able to figure out that division by (1 << n) is
shift down by n and it's easier to follow that way...

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
