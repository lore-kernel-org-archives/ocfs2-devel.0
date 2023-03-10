Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46480C64EC4
	for <ocfs2-devel@archiver.kernel.org>; Fri, 10 Mar 2023 03:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=S6kCOY+5TvijoY6im6hqLW9x1oRqqTRfNrkOgvIa6h4=;
 b=N9byNfBBLXs2WDhaYGQ1MlvUGsaHnH0OrO6j+2GNv76F5s6o5/D74tBGEeN6oLq327CIQ3eMpO3K
   YgRVSi+ETIaN7Ls/E3YhH/V3e2WYdSxqMW8TczSNvQ5aSpNIobv6udM1nrLMziqNLqYvrRCJJ8Hl
   EyWsQJsWpTQrTuX98xn2LY3cqRkv134G1R4J3MA5gCHBvEazuyLEqW+Fe2CcB+cSZU+MDgVojNDY
   fZhP/E1kk4iF72NG0MkhXiLGy3ASs6ItDOlwta7TaLM5gP4B65tlnlXjGcHd42w2y21ye4nxn8Ur
   l2OxBN95nUyrQ2VBJmsozrscaNiMhvoWS9/YTA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=S6kCOY+5TvijoY6im6hqLW9x1oRqqTRfNrkOgvIa6h4=;
 b=uaFwsmwK+H54Mm5YBiHoNp334K7lj5HXwRJd0+On13Ztjvo9s+hPDFTdW8gNvvDvOm2lVDe2JVDx
   1WFObpPFRSFSGTkeEipwLrWp6DflmaQhcthXER3ckHAOCT/Ef9trc9ZzvGZwV99yXt77UoqF/gUL
   QISgtj4XB8CzJb+2sJODza4q81QSyIC12pUVfvosDQSX+alzdrdlGQ7zzp/eJCGuQMfTrKVnniuc
   H00jjxOYNrJH4XjgaO2Wul2so1i8vQp7oSNjpDHcm6yTEBHLNYObJakQpSNQ08+rdWsfvMHAAvcX
   GsYzU8PowHVVHO+ZgQWwKgpgU/DXf9piQNnCvw==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRA003OEC8QHQ10@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 10 Mar 2023 03:26:50 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=u8e2ZdAGsrDs5mc8tdhL4wOZzMMIPUZ2NIMj6U1DMDU=; b=EyM1eRQycjfDodnwphsbE/w0GD
 4GSBdTKxZjNXgFXT3S1cfE2Cj2w7p++EBUL20k8CV/WQ5IJV6TnxjKIHfOp23yKTH1yv8sH+bnhso
 NQzHkrlD0K6ebfI0YbzvAaUrXy56zWlrvdGLol5HZ0gTtl6Z/sxYpU0zPoxR6V5CSKsaAUM0+xfoG
 Crd/TrAtj1NTfS8pi4d6K9U9JcIa60NnEM+2x2Tia4PS2feU2NQ7VPBycgaCHA7/z0P52ZZ9Zl38H
 NOKFsMJWnEN18CIiLLqiZyw1pERtByrbV4R4qgBHCXcbx6wXhTqQVHbZo2gmfRWW8wrreGNuhKout
 AUZwnThg==;
Date: Fri, 10 Mar 2023 03:26:11 +0000
To: Yangtao Li <frank.li@vivo.com>
Message-id: <20230310032611.GF3390869@ZenIV>
References: <20230309152127.41427-1-frank.li@vivo.com>
 <20230309152127.41427-5-frank.li@vivo.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230309152127.41427-5-frank.li@vivo.com>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10644
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 clxscore=166 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 impostorscore=0 priorityscore=60 spamscore=0 mlxlogscore=938 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100024
Cc: brauner@kernel.org, tytso@mit.edu, agruenba@redhat.com, chao@kernel.org,
 linux-kernel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 huyue2@coolpad.com, adilger.kernel@dilger.ca, jefflexu@linux.alibaba.com,
 linux-fsdevel@vger.kernel.org, xiang@kernel.org, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v3 5/6] ocfs2: convert to use i_blockmask()
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
X-Proofpoint-GUID: fSA1WrMx6_bmuqTRJOf0dcNx78dAOs0p
X-Proofpoint-ORIG-GUID: fSA1WrMx6_bmuqTRJOf0dcNx78dAOs0p
Reporting-Meta:
 AAFQ33ORoE37IzOxb+kxlkvlqDCHpFUwTHhV/6eZuFQCmrSQC6PPZ6Q67tc61AZB
 xC8BNAHekStZC04odlEql3p70VNVP4JTgqbnyn6wSIiObscF4YXJtpYLziZtdL8y
 0nLBNCN+Vu2S6gcp6Vvh9Jn5Osbiz7uDdBFLF+9RQMduJQsPXRvFGVKvvQpu7g7G
 TDgw83qBpI/yNbZoBrR2QOB5JIziWgHUoJA3TGzjjqVxwJwK9u5LJ8VhQcavaF+v
 AJCEutPqLx6/HDe6XUHaCCXKErLndySqaA0jxgikVHJxqja2SG7RC0p3WB5Dt5V0
 ctXdRgRaNtdDAUl1dffpHr8noITnfOutLJAtS+gXr9wkhyKvBTQO4UNAsHMwIekh
 P3UC6UVez8Qzk2Bxmx/f18mL1nkJwiaVNhetqwDj+L4HDlB92BGK3VKFRYQGaqqf
 qjnpYjVsqIXj2xd+IEhRYe2WvTakaMTOTLL5LBOUcl4aEOeTtmucqBybeSPbPI1x
 e+n21lJWRs0uLOI5c1sy5ajVl9C6sLPZtZc7xHSmfyQhtQ==

On Thu, Mar 09, 2023 at 11:21:26PM +0800, Yangtao Li wrote:
> Use i_blockmask() to simplify code. BTW convert ocfs2_is_io_unaligned
> to return bool type.
> 
> Signed-off-by: Yangtao Li <frank.li@vivo.com>
> ---
> v3:
> -none
>  fs/ocfs2/file.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index efb09de4343d..baefab3b12c9 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2159,14 +2159,14 @@ int ocfs2_check_range_for_refcount(struct inode *inode, loff_t pos,
>  	return ret;
>  }
>  
> -static int ocfs2_is_io_unaligned(struct inode *inode, size_t count, loff_t pos)
> +static bool ocfs2_is_io_unaligned(struct inode *inode, size_t count, loff_t pos)
>  {
> -	int blockmask = inode->i_sb->s_blocksize - 1;
> +	int blockmask = i_blockmask(inode);
>  	loff_t final_size = pos + count;
>  
>  	if ((pos & blockmask) || (final_size & blockmask))
> -		return 1;
> -	return 0;
> +		return true;
> +	return false;
>  }

Ugh...
	return (pos | count) & blockmask;
surely?  Conversion to bool will take care of the rest.  Or you could make
that
	return ((pos | count) & blockmask) != 0;

And the fact that the value will be the same (i.e. that ->i_blkbits is never
changed by ocfs2) is worth mentioning in commit message...

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
