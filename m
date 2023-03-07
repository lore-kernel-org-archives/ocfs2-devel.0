Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A3C5C6FD1A
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Mar 2023 16:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=I+guS3Pv4caxoCvAWqUuYTk7GN6PM4wMNlEgIR/GK5Y=;
 b=g/fuC9NcDKFozFO1HPstPPURF5W1SAvwUh02FbCIG3vtybVKxLkPo4Cta/8uBk6q3DXM1YCVF/2G
   xNxoXFR43h2E+6SRSG/gdlJ31IiNMuleHLg2mN2mGLWY8BJG5B4b33YztJTaF8Yt1e9sq85EBMeC
   RnNKRy0QYm95MK9pAQ7X+WTazQr7DVnSGnU9DtZyMi3PC0I215eb2wiFvdp4zTNoOZBe36JPPWKw
   zBe7NC/wyRAgGrzMmk+VJ3S+xhoeUMplPh72B5VOMSU93B/JqkRrvGhWSrVuGP6847EjSngZI9QR
   MtJervbda8mhJKqf7U24bz2OGckWCPnukW0gvw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=I+guS3Pv4caxoCvAWqUuYTk7GN6PM4wMNlEgIR/GK5Y=;
 b=rYmiNAP5UTVfVW4rGki43DNREek+fvyTN5BRo70XMGA2vpfen7nKgQKccBWketv/ea7ZrsFYQMYJ
   9LPCqNgE2I8ZJOMbJfIhskVjVAFdSHMW+3p3tF+lLksRTAUP91Cy/kz6PVNnBXIYvkBmzSmxJSdZ
   oL0iUiQH3wqxI55O8mdyA3qguemDnpIu3PbkJHhNeizK6kcPx3jrXVeRgAj+j3luCUJPvOryakjx
   Bu6WE9fHR4MOpaDCo+b6alKZgYmzVKawohZhc/HTqzzuJ5ETPf3lLvtj43LZPapKYSRn3NwmgNEY
   INLxrEX8DPAC4jo7hXepfmEzyTyem2jibHujog==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR5004J2S3TJZE0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Mar 2023 16:21:29 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=message-id : date : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ns6zsO5fHaTPI7ky3o4alzUb25um/KT+S6ycyGnv/68=;
 b=a0jtV2B4QHwJqVdpMpcjNJTlZLG78nT8eGPUnCAP7QViZm7oU1E1YEJ4qftBs5xZ7IOO
 BPz6vlymuYR5MqdnBIpwOTs/2rp+v4gGp4Ukn5rJpU95BuzAjrzQzNnDtDLIvlyWp2cV
 SrBuQUVw//gbeMxskT9SCBkDkOcYkqvWFSQiylsHwZ1CMLbsa7Thhof6GuBx0HQQ/URN
 Eu7ruVnvQXWIr0DCarlz9ai7ztj2h3upV/Zq4FXRo0CIHOTM71qZcwyrq4yYfhzYFzSL
 0ZxKV8UVaCWMIrhJxP+ufQ1j3vCc2X3VLxW63o5xn+ABT+2aPcdssdoG7nibenAaexno /g==
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gd4MfpneTH2bInfYLs2OXPqOEL91zTi3mgtx/cufBiJMIWfJ6brHCoTPpO2sBTC2MeYIpIXLlAWXrl3cwiHU6SO5PmOxVFv+Hhsd/SuKA2+h1uasbbVKG+OvcNyPumLHI+5iesZoSV1M6+3bGJ2Sd5zMOeBLqnYYDKItuqmRJYPwxKUUsW99+h7en0919BR3Ztql8mcRov+3QA9Y3lpl0L1Fad4r1MX+fh96Brb+y9qPqP/u22t5hKwGJUDCnc+qYuk0Hw1CxR0cJWP377WTNtJDMuEmHrvluC1QOpmdv9j1HwYDvjzbDBVNiBQxX1iUkG66P23h7KrEPyC1x0ikIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ns6zsO5fHaTPI7ky3o4alzUb25um/KT+S6ycyGnv/68=;
 b=E5YhGsuGQGazf76WDuTn2mlVl1g1YTRm7aQDBKBeZgEJRXtuQgUPZmg1kZoON/nvXCtRnuzjxXuzdD7I9C7D12Ljy7z4e6JwlZ+vIeCk/207jOtqSWW1eBa6t+hxoGAtCU5Z/dACuQvaNPXNREyfTMWt6VJawaRUCAY2OgNxETaUbP3mTwrRZJ8p/U8aVKNMyUsAwTI8cnImQQNsNJq+BMWxs5lOUT3uxj996zXNYjPO3sJLLOksvlfZLzg8985n7vQoHDIRIELwodTep0vcqlD97Ocuq9GqhW6d5zirR4QRNg1w+gduKtj0mHZVxKC8VBskxm9pmqtg4uX3WCdN2Q==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ns6zsO5fHaTPI7ky3o4alzUb25um/KT+S6ycyGnv/68=;
 b=aZaH30NzSeIRZ0XDnKqsRAyXde/bjGFDpBeIYZTbpJ+xnIJC8t6vbKUvMNPVZp0cEDw2ZWrRq+dhs6r8UFHHqBp+saZrV5Fbb7mi1nNiHXh7DBVsEOPD+0bUGtPCORIrNYeg8vSzDeVSaJyafkbbpdwewaBXzf/YBA9kiqGRcP0=
Message-id: <6782ec9e-ec0d-396b-0354-592554e74ae2@oracle.com>
Date: Tue, 7 Mar 2023 10:21:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-language: en-US
To: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
References: <20230307143125.27778-1-hch@lst.de>
 <20230307143125.27778-4-hch@lst.de>
In-reply-to: <20230307143125.27778-4-hch@lst.de>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:MW5PR10MB5738.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 16:21:14.3132 (UTC)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_12,2023-03-07_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070146
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 3/3] mm,
	jfs: move write_one_page/folio_write_one to jfs
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
From: Dave Kleikamp via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Dave Kleikamp <dave.kleikamp@oracle.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: CH0P220CA0028.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::7)
 To MW5PR10MB5738.namprd10.prod.outlook.com (2603:10b6:303:19b::14)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR10MB5738:EE_|PH0PR10MB4679:EE_
X-MS-Office365-Filtering-Correlation-Id: 08e38df3-b46e-4287-4b71-08db1f27f8be
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 Fuw/UnnuGSmfvjYI8c/5bA69aeK+zVCe8Q9BXVhBmL4VTZdd4hv6fmpa396SiCOPKcTbwr9FCxT4t2K6RgkwctJqM5kvpz71KAnOqXP+mc4TjQ2iNk+CWwpSOvuyGvE4u4W97MHC/o8wW+FMD7XgkgNuwlLTggJsm0y78GQKfHzO+sQeJ6GuXFjjpxtvCiZ6WKyHuvr2PcK6ztHL2mlLhY9sgzo/ci1PMWo+GYofZxil5/B2QKu5rZRDbFhF7JGYa4dr50LCq2cEVY58OIzXGQrlWKG9u+4F9DsprwbBCRl3v0cTO6DHzwgsjLo+uGIgZHzsXopEMWfKH8AmXKRQblQiltasSjv+r2fn1n62iEMuTPU6IrxHWp+1V25pKN20MEul8dOHF+0YxqD29rGQqUEmuR+UjUNHvUKja43s0ffD0fwj8Xb/Oa0UQ5zPDLrEQ+ceYeL9NUU7TY/i/zOHJvoxTN4YkeRZkigIlyojDau988HWKrwDx+L7aT1L0l7QRbqdLjS7wlK/kCtAY2bbSZgHh69RSMBN81YPakTz1EN7rCtNSKsmBTFncyYXTtlR4DqZhhdO5CoPzQoKEUURKGbbqu7qka6koklbU2naoSgA2j+6jpRy+ou4yOK3yIXqazhrAayH7upED/a2j0cXzg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 4gj9U/Jee6tHlkRVe+a+Z5kNQBltADkw0y9K8as6DiMgtWElK1R+yRYu872EE8pp3UKD5B5cmt3ZjXi+QuXwJ1s2fCLtNqZoYiI6molU6qiYzUK/A0ncllKLhK8uR48GeqcqMbArNCE4y6KkY6c4os272U/G9tcL3g+NtHF2dtRgRNxCJHmYfa14AmAplm2A2uwHJf3jxyqH1AVmdagxlkMaUroux8229cm346BELtOQjQ7rgqr9w8mDbD9mPrnDUVI5KDp/FSfyebJH4zm4HF0xf5l4hqmvlTiUvsPeswvnZXgwi5zlgdAweapRrpip/+5GvoziHR/Qd4383z2FN2TQwGjqoQhb6y1dqYdUR3YMRFTWPRWAPfufCazGYcwQWQmBjuupPsqlIzeovhPju1Z2yV0Ik8JzjDvQTC0z927V2YyRkrot85yjP4JpxG7XxQx2yAg9jTAP9TL/15jTnIh91WrB5weTEsraw3gGHyj0DmamfVO1yT9m+42exykqZtI/Q2Q/uDeunGLePu75L4H7FXfCAbK5nPtpFan35LH2YB5k3ZMW59JYVdGQwBECksn4Ppro38Ye2i5LScQr2F75vvQnZyJNCfiJ8Ue03LKZs0ej3QTYuhfJ4lGzwOBYvqz5gMvT3uX9sRkPg811slOybZTy8i39Zc8HW25dIRKO+KcHV07UwAac/rs0POeWYiLWCiWLCYoUDHW4W1810/cwIe4zLqbPxoa7CqrnqwmFERgjSGboUKf2EbUURnc3
X-MS-Exchange-CrossTenant-Network-Message-Id:
 08e38df3-b46e-4287-4b71-08db1f27f8be
X-MS-Exchange-CrossTenant-AuthSource: MW5PR10MB5738.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 gKAzOYJfOuTsYfO4ALpjRKjatrrtEhxkgsWiAwrJlknVP9jVe2SsdanRglKgtELiHSJTco2I0EqSA1NbsIlFu24Ax7h66g2xbgL6bowUxAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4679
X-Proofpoint-GUID: SFEI8QjTEun9eiGopSxVyr_nyjuwsXBm
X-Proofpoint-ORIG-GUID: SFEI8QjTEun9eiGopSxVyr_nyjuwsXBm
Reporting-Meta:
 AAGofkFhkToIxgGeppVx27rnlLec8du9xm1WRf0ANh63XVf5VCZ9qxj8F7BGhR68
 y+ntbCBvkZTRCI7HQ/ovnNaElK4lfUTZw7wcsK0/rU1CM8Iy7dquNC2YSSMjx2pe
 i4A/btsD2Co3wxFhiQY/IJ5rMMktkko2HYqublmlZ4+ibqiKVKw6YyqUpGEQHm17
 syqIySMW3GoAzeNIE7DUOULLWDMY6sWHoJsqydVMap3wAZOq7EoPx0yDEUD462/m
 Ra4Ev56+AKSXDzaocaqMAKPDpbZAXOOGWOu2uOE6/ysgj41ee82vI+VvFaU2mNlJ
 HN7oGQB8o4pRFWNOZLiq6T3mctXyL7kkJSnUjKPo8YbsCBlderqx5x8heF3nhiq6
 i83HIzgzBrUY7QcZxbsMH7DQhtn+1aJnYnwS95ddeqWRPa3fnj9FM0eHcdJ2KPxp
 YMPCawhsxgQRBWGaGox2OUOLwM+cXD+BDAyl0dzLKqf9yIagJOvIBrYUEFSwqbMB
 vvBWBX4K6tU/w+HSyScQWX7Yz0eRk2lMoHRPZCt8SvSJKg==

On 3/7/23 8:31AM, Christoph Hellwig wrote:
> The last remaining user of folio_write_one through the write_one_page
> wrapper is jfs, so move the functionality there and hard code the
> call to metapage_writepage.
> 
> Note that the use of the pagecache by the JFS 'metapage' buffer cache
> is a bit odd, and we could probably do without VM-level dirty tracking
> at all, but that's a change for another time.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>

Was about to ack this and noticed I must have done it earlier. For the 
record, it looks good to me.

Shaggy

> ---
>   fs/jfs/jfs_metapage.c   | 39 ++++++++++++++++++++++++++++++++++-----
>   include/linux/pagemap.h |  6 ------
>   mm/page-writeback.c     | 40 ----------------------------------------
>   3 files changed, 34 insertions(+), 51 deletions(-)
> 
> diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
> index 2e8461ce74de69..961569c1115901 100644
> --- a/fs/jfs/jfs_metapage.c
> +++ b/fs/jfs/jfs_metapage.c
> @@ -691,6 +691,35 @@ void grab_metapage(struct metapage * mp)
>   	unlock_page(mp->page);
>   }
>   
> +static int metapage_write_one(struct page *page)
> +{
> +	struct folio *folio = page_folio(page);
> +	struct address_space *mapping = folio->mapping;
> +	struct writeback_control wbc = {
> +		.sync_mode = WB_SYNC_ALL,
> +		.nr_to_write = folio_nr_pages(folio),
> +	};
> +	int ret = 0;
> +
> +	BUG_ON(!folio_test_locked(folio));
> +
> +	folio_wait_writeback(folio);
> +
> +	if (folio_clear_dirty_for_io(folio)) {
> +		folio_get(folio);
> +		ret = metapage_writepage(page, &wbc);
> +		if (ret == 0)
> +			folio_wait_writeback(folio);
> +		folio_put(folio);
> +	} else {
> +		folio_unlock(folio);
> +	}
> +
> +	if (!ret)
> +		ret = filemap_check_errors(mapping);
> +	return ret;
> +}
> +
>   void force_metapage(struct metapage *mp)
>   {
>   	struct page *page = mp->page;
> @@ -700,8 +729,8 @@ void force_metapage(struct metapage *mp)
>   	get_page(page);
>   	lock_page(page);
>   	set_page_dirty(page);
> -	if (write_one_page(page))
> -		jfs_error(mp->sb, "write_one_page() failed\n");
> +	if (metapage_write_one(page))
> +		jfs_error(mp->sb, "metapage_write_one() failed\n");
>   	clear_bit(META_forcewrite, &mp->flag);
>   	put_page(page);
>   }
> @@ -746,9 +775,9 @@ void release_metapage(struct metapage * mp)
>   		set_page_dirty(page);
>   		if (test_bit(META_sync, &mp->flag)) {
>   			clear_bit(META_sync, &mp->flag);
> -			if (write_one_page(page))
> -				jfs_error(mp->sb, "write_one_page() failed\n");
> -			lock_page(page); /* write_one_page unlocks the page */
> +			if (metapage_write_one(page))
> +				jfs_error(mp->sb, "metapage_write_one() failed\n");
> +			lock_page(page);
>   		}
>   	} else if (mp->lsn)	/* discard_metapage doesn't remove it */
>   		remove_from_logsync(mp);
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 0acb8e1fb7afdc..853184a46411f4 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -1066,12 +1066,6 @@ static inline void folio_cancel_dirty(struct folio *folio)
>   bool folio_clear_dirty_for_io(struct folio *folio);
>   bool clear_page_dirty_for_io(struct page *page);
>   void folio_invalidate(struct folio *folio, size_t offset, size_t length);
> -int __must_check folio_write_one(struct folio *folio);
> -static inline int __must_check write_one_page(struct page *page)
> -{
> -	return folio_write_one(page_folio(page));
> -}
> -
>   int __set_page_dirty_nobuffers(struct page *page);
>   bool noop_dirty_folio(struct address_space *mapping, struct folio *folio);
>   
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 516b1aa247e83f..db794399900734 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2583,46 +2583,6 @@ int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
>   	return ret;
>   }
>   
> -/**
> - * folio_write_one - write out a single folio and wait on I/O.
> - * @folio: The folio to write.
> - *
> - * The folio must be locked by the caller and will be unlocked upon return.
> - *
> - * Note that the mapping's AS_EIO/AS_ENOSPC flags will be cleared when this
> - * function returns.
> - *
> - * Return: %0 on success, negative error code otherwise
> - */
> -int folio_write_one(struct folio *folio)
> -{
> -	struct address_space *mapping = folio->mapping;
> -	int ret = 0;
> -	struct writeback_control wbc = {
> -		.sync_mode = WB_SYNC_ALL,
> -		.nr_to_write = folio_nr_pages(folio),
> -	};
> -
> -	BUG_ON(!folio_test_locked(folio));
> -
> -	folio_wait_writeback(folio);
> -
> -	if (folio_clear_dirty_for_io(folio)) {
> -		folio_get(folio);
> -		ret = mapping->a_ops->writepage(&folio->page, &wbc);
> -		if (ret == 0)
> -			folio_wait_writeback(folio);
> -		folio_put(folio);
> -	} else {
> -		folio_unlock(folio);
> -	}
> -
> -	if (!ret)
> -		ret = filemap_check_errors(mapping);
> -	return ret;
> -}
> -EXPORT_SYMBOL(folio_write_one);
> -
>   /*
>    * For address_spaces which do not use buffers nor write back.
>    */

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
