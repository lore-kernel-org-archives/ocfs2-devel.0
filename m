Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E91CC77B6C
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ew5mUaw2IJvF8kTkF48KOQytaqi2s3znlYaMRX8dalA=;
 b=Nfbtl77+OdlJmgSm2aIh553bSNpid/gV5aTVbAHbo3aVYslbKBUXuIQT29NaXkUTDpI8DKbq7yIA
   l0xdcq8O9Srx9ILz2dPtaJqczj5sIB1O4WqJgknFaQleMJzlcoo3OfcGWan/pro/syjcHF50EdjM
   Bv3uVpKJwfqKTaYTCJ5G7+KO4kANuzvoEvbWJYm6WUaB768uje1HlOEb6SV90T8AhMJMzvfJMazY
   T3sqOMlIQNLSdIRgC8hnUrcEgfNkzCqEJ7R9TIb1DZ7o9wrdmGTGG3Coq0HrSJMxIqmVro+qwHvE
   l0HEPNj9h5lLdqz4kINBJ3qPfmq1Iy+2gN3G6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ew5mUaw2IJvF8kTkF48KOQytaqi2s3znlYaMRX8dalA=;
 b=rd0FlVr0zCSuCv6oX7I1ew4LyLP9EJz231XV5QTOeSXDsP7EdNxn0zzcfxnompYsBbP4WcUVOq1s
   V/1qULuRHqaEMw2Xf/I1Trk9PqLhHQSsIQ1jTq39BApa0gZ0OS7e1KXu+LHUkfhWXTI/XPfR2fzv
   bhEsxMXE3RwZeCEuGjKIhEg5ToLy8fsO24u6W/MAEvYC/HbGdVnWq7/w40C/lUGUcxM+72HynYVV
   d/i8ULs+2ldovZnRE+vCTOCFdf+Xillg72hPB/CKFEUhID9XxRftD/mx9gBILhewvfryvBW8J2k5
   APgBgYD8td7nXbCeHfDprSPQWcKEbxacn5VBLQ==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX00NH0M1A5CC0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:10 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=wdc.com; i=@wdc.com;
 q=dns/txt; s=dkim.wdc.com; t=1679297190; x=1710833190;
 h=message-id:date:mime-version:subject:to:cc:references:
 from:in-reply-to:content-transfer-encoding;
 bh=PznhUX2rDF8uhJla7kd2cwVnZx5w5yiNB4r5BQcdnfM=;
 b=NDYRMpMW9w25llPw6B+MrBEOlmbHwGgS56NyCPJ2DSLdO3faO2fua9sQ
 GwctIW8NtlZaQahM/c5LG9ncoHuA9UHu24VaCnsuKjTFf8L7qNRi0SsfD
 sCNllafNp1m1r9Y3A0+B40iKcSHHTQJVBcHOobaqoALGCJQ2UYqAlP78f
 +Mqa+ZyvuXeqTHZwu6JLk0r/ADQgpMxTLwbERGajsG4i9kbEgxXzjZSY+
 2PyPRsOcPlAFkpnmMnanMMhYEkJbRJhxRV1saTlmsmjTBU24DI3RuZiys
 IHHWPLW4zEN/IyRAW7Ck+J1fY/Qj5bZ72s/1BrQQVI3SyMziUcbwXLBaP w==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d= opensource.wdc.com;
 h=content-transfer-encoding:content-type
 :in-reply-to:organization:from:references:to:content-language
 :subject:user-agent:mime-version:date:message-id; s=dkim; t= 1679297170;
 x=1681889171; bh=PznhUX2rDF8uhJla7kd2cwVnZx5w5yiNB4r 5BQcdnfM=;
 b=cGktEt0ZdJR8KuWIiBKgGF+rJgFflCsYsHXzfYTNZrejmcOXWcG
 bOcFw9iHNtb6uelk157fCD4HxU9ePigeJ3X3tR0MBjiCaT/V4IEzeTSH0gEI+cr2
 FmI8erDw8xD5abRdKCzlc1jXv2JzC6O4pCFCDUl4Unt/tCkL6K8ObYmUBErSOhB5
 PNT1sbPiJM8KGavYNkeNKy2dzbo9h8XOFyXMMDreE2yOT0MLABF6FJ+o8TFM8dik
 BdOPVkPqQGCQpGB+8r02kehuxNeN7rPK+ntZnrXITmh9mCVwv5y+6kQSEJHPxPsE
 xI/kRRf3Tyx+hsRspoBR7sxhuuCZSEc/e2Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Message-id: <982b6aa9-4adb-acef-d9d7-9a1764a66213@opensource.wdc.com>
Date: Mon, 20 Mar 2023 16:26:00 +0900
MIME-version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-language: en-US
To: Yangtao Li <frank.li@vivo.com>, clm@fb.com, josef@toxicpanda.com,
 dsterba@suse.com, xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com,
 jefflexu@linux.alibaba.com, jaegeuk@kernel.org,
 trond.myklebust@hammerspace.com, anna@kernel.org, konishi.ryusuke@gmail.com,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 richard@nod.at, djwong@kernel.org, naohiro.aota@wdc.com, jth@kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org
References: <e4b8012d-32df-e054-4a2a-772fda228a6a@opensource.wdc.com>
 <20230320071140.44748-1-frank.li@vivo.com>
Organization: Western Digital Research
In-reply-to: <20230320071140.44748-1-frank.li@vivo.com>
X-Source-IP: 216.71.153.144
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10654
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=166
 lowpriorityscore=0 phishscore=0 adultscore=0 mlxscore=0 priorityscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=564 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200064 domainage_hfrom=11266
Cc: linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, linux-mtd@lists.infradead.org,
 ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v2,
	RESEND 01/10] kobject: introduce kobject_del_and_put()
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
From: Damien Le Moal via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-IronPort-AV: E=Sophos;i="5.98,274,1673884800"; d="scan'208";a="225823541"
X-ServerName: esa5.hgst.iphmx.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 exists:%{i}.spf.hgst.iphmx.com
 ip4:199.255.45.14/32 ip4:199.255.45.15/32 -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: brECpB9vCvjb1EcHwV1KtamicVe1uFTi
X-Proofpoint-GUID: brECpB9vCvjb1EcHwV1KtamicVe1uFTi
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAFxrwKTSJy3Y8e5YKnJ9E2HBA4/1xu+l4bdyOIPIyXvoMi4J8WACc5vrqjONRoy
 +cQqerDztDoi3nSQ83cjQUJrLY2qj2FMrHRUQuEQ0QAMd9VX10gFlxoxXfxttgDl
 GLUkUG8Mz60W8Iyk64cgLJP8/HqoHK6Jcl3Nvad/GjvG1g8MjX80bNe6FWoRjftf
 +l+dn+CbwpPxKvTVKGQ2ARU0khG6ZEYGNrr/kACgzJiYe7KDgveJ/Ql8i4alqO7m
 Z3tOyeYszCujWcJBQtTGIKKgVjdIbbFs1LGsyuCqZ0mf4/QKybSyZzikRX2bHao3
 thM3AgRMUurRer22ci4e1w6yujm52DGinb7WFlhmGQ1vTpNMj4HdgT/kXy80aRyz
 gp4kB1dQard8SQBzgnPEEXkQnqRxgtxuAV1Kdrq9gXRlBoo/xxxl307Zt4uEFYHk
 eTysRIgUVU/VxF+VFgYklwmZmtOIfuHNGVNgtpkHOZ7D980IaAAJTK41YMcpT8H3
 7fU68nEfIHSDjY4yYRA00MMThATx/W0gV9UqnwdkX0PS
IronPort-SDR:
 pOd9yA+cKTM/NQ5at4NuwGOmDQ0d0/SS20FXWqiC/H1C27jpsGocOcuLhn/iaFaFDRgzlQPoS3
 BGEGs3sr1KXf6cuFh1cgS4gRCeNHQKWVTll0og4Cs5/8kxb5j7fZ7GLj+SwB5KP7SnXTPzqv9S
 x/OaIpFO+jSqW/wmKWXWsfbDzObQ4CH9909GJDQ5vXOzG9x8hDkw1Kuhcxj/NK/lUNPc09djwo
 Aeduk8piY2i9jhlPu9zRhEs4LAdXgYEn+PmAkUUuxEWZ8PlvbM/vYOyl+UwiLQQfKijvLwXgyF Xis=
IronPort-SDR:
 O8+p3qMU3IUM3XpRUCLESU6iGpHUJZbWESWu+acuXQA7M0nyndRwTVBRtsfP1ORDV+OuQ5lWpY
 +9w44ziDRpo+aiyHvMgcw5ImEn4KtWZ1rnHs3vwzmg5CesheOp5DG3e7Rrrhjqj7SepiSj8DRp
 S0YWeZocBOnosLL4HRUl557YD4t7xCSBI+dPSvq4I5Ag5YuO8pg5hBwVoymFrj25JeHdnaEBSW
 2nnnzjyjcuMy5HAV2OX7fSAu9XnmtiCIrwMSVrQZL8cpmrVcm/HDQIKz9IurL0vEcq1d5faFBQ iE4=
WDCIronportException: Internal

On 3/20/23 16:11, Yangtao Li wrote:
> Hi filesystem maintainers,
> 
>> Hard to comment on patches with this. It is only 10 patches. So send everything please.
> 
> If you are interested in the entire patchset besides Damien,
> please let me know. I'll resend the email later to cc more people.

Yes, I said I am interested, twice already. It is IMPOSSIBLE to review a patch
without the context of other patches before/after said patch. So if you want a
review/ack for zonefs, then send the entire series.

> 
> Thx,
> Yangtao

-- 
Damien Le Moal
Western Digital Research


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
