Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E09E1C4332F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 21 Nov 2022 07:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qUUKjiVOUnn01+Du/FcFLmNDGNL/z470VEYg9E4/VCQ=;
 b=uxN8GRgPwnqRy0ZJEhY5BnMSP3t0omxE3TKhv2usYtntQlxsE5ziXFuygUlLFqQpVS5C9AIaQfTp
   w0x5GRwKe/+4/6+6UrD+kI/N5y3aRx7WPrEsWhjw+z3+FSBR5Dh0NHaQjPieQY4xKkGqNLRcKsxC
   RGsDERDTCPmwXxO1MPOrmtmIWXx5A4QC4rqXmtpZv7kpNO5oVOsimEC362CuaN1hPDqB50cK9tw3
   vSBR6vj8HuIHzEmFvVQ6bsN0oFq0DoW8nhhjhAN8fCPVSQ7loRLdNnFFqAL6nzI9QnuDAqSo1b+i
   yF3N4KvTdXJZpHCWTZVphGa4cBHb0r27OoOwUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qUUKjiVOUnn01+Du/FcFLmNDGNL/z470VEYg9E4/VCQ=;
 b=daHJJ8Z/pK0aEQyhKJGp7o+XmJtImCeZOJnyIRQ6U+gOIAgUInpVymCmRV6WWaM4DB1lKxNXXTv2
   rGvmPI+JuR6xX7HgEbBjxarpjr2eGRFqmi73Bd4qZLlQ82EBGfOm9JizjdlrnsQY2cXdpo7pKIW8
   5U62MMzUdJqF4zHpL0euU6QITx8QxBU/iM3F+7XIWcfMm+a1HTrTuVvJ4Vj6GEz+7f/Lu0dUh6+g
   JdNPjdUYN2vmGEThoYmzMG0YSBS0HMHs1SIiUX/6DORyFs+vVXJUiNmoDYGlyjhUOlfns+HNrkUT
   4YmpixOrJ/s6SXROmNM0rC3w6IJdm9NukQX26Q==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLO00HE2SQ2KGC0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 21 Nov 2022 07:27:38 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=alex-at.net; s=default;
 t=1669015634; bh=FPwSbToavWSUtmSs1xGlcZ0g98oQNCMSMGzR+QTLrQY=;
 h=Date:Subject:To:References:From:In-Reply-To;
 b=uogiO4iIUh4j6dEOAwsk8+UpPywnn9TEiV4OEiJQMqOP0tn+0Bu0Fi9MrC73S9GsV
 J/vNnhYJVmHsqhjs9EXxY1oR9ysty/LcDcq4Ay4PIF/4Ae7EbxDE/8zOKoUKgRsmbA
 0kDoxNVoOIF4kuCsgsZ7uKXCVATigldyHjZK3pIg=
Message-id: <121814ae-69f6-2d1b-fb83-46d3a8da32e1@alex-at.net>
Date: Mon, 21 Nov 2022 10:27:13 +0300
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <d7a1e5ae-c43f-5a6a-c0c6-619a3e22b092@alex-at.net>
 <911762fa-8fc2-ec01-e767-1ed8ae7e5c38@linux.alibaba.com>
In-reply-to: <911762fa-8fc2-ec01-e767-1ed8ae7e5c38@linux.alibaba.com>
X-Source-IP: 51.195.137.138
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10537
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501 clxscore=-49
 malwarescore=0 phishscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 unknownsenderscore=20 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211210058
Subject: Re: [Ocfs2-devel] dinode link count inconsistency in
 ocfs2_read_links_count() logic
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
From: "Alexey Asemov \(Alex/AT\) via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "Alexey Asemov \(Alex/AT\)" <alex@alex-at.net>
Content-type: multipart/mixed; boundary="===============7889007914816622528=="
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: mail.alex-at.net
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 a mx a:home.alex-at.net a:sphynx.alex-at.net
 a:mail.alex-at.net a:mx.alex-at.net a:home.alex-at.net a:sphynx.alex-at.net
 a:mail.alex-at.net a:mx.alex-at.net ~all
X-Spam: Clean
X-Proofpoint-GUID: AwSpbRnDBkrq27Xb_ey_uDF1D1ePeJ5-
X-Proofpoint-ORIG-GUID: AwSpbRnDBkrq27Xb_ey_uDF1D1ePeJ5-
Reporting-Meta:
 AAFQE9LRHghwhZoy0iExpeegNL/s5wAK2GOr+ZCdABUZ3XBgob0ZWLRZHX8q8rak
 5yO1ohLMehUVmoHzTW8Z7rSe+AA4L83x2Jo5KmPXkCuYzBCBIjQ6HdfAwO26WZFq
 6oTTvww4u9ugkPDBe/yntynI7VIApTlNPMvDrxaFytqw38c6YZ6OEgYey4UvtGh9
 Uro5DEgIsDRs6YNJKmfuPxsuMpQNvpPIMKSDTe6+UJeypqwixzahMQgNYgICxvD+
 o73xQKkChJ+LTFwsKniZDKaOB825C8Y8HEN48kyj+AQB5OggL01zU6BDtFFpO/ZV
 ioxBOInBJ+VDGgnqLdZJpKfCtlrpuOiqe5pFF4t246CUmZMoNaOJBQUoRXUUOr5y
 tQMB0j5eEA4unRmk1DLYdqoWjDaXrP+kHpJnw0/BV+EBlObHGVwSLQhaY5xQwacU
 NA8ZrT1ZDKgn0V45I2CJYH3ErYsZPsYKMBhunEO2nKF38hcBNhEBf2czazgDcOHN
 NOhT4/bMwTx3NojnQZzrCnjhHyUGrI8O9cz0spXzUcgn

This is a multi-part message in MIME format.
--===============7889007914816622528==
Content-Type: multipart/alternative;
 boundary="------------Ab58Hx61jJyQhoN2v8iyhaJF"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------Ab58Hx61jJyQhoN2v8iyhaJF
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

ocfs2_link_max() relies on filesystem wide indexed directories flag, 
while ocfs2_read_links_count() relies on per-dinode flag, and so this is 
the exact inconsistency in question.

I am not versed in code enough to be sure about exactly why this limit 
exists, but it seems supporting OCFS2_DX_LINK_MAX is no problem for the 
code.

It's just optionally not adding high part of link count just seems weird 
to me, the field is there/zeroed even with no indexed dirs, so always 
using it feels logical.

---

|

if  (ocfs2_supports_indexed_dirs(osb))
		return  OCFS2_DX_LINK_MAX;
	return  OCFS2_LINK_MAX;|

On 21.11.2022 4:31, Joseph Qi wrote:
> Hi,
>
> ocfs2_mknod()/ocfs2_link()/ocfs2_rename() will always check
> ocfs2_link_max(), so it seems that it won't overflow.
> I wonder if you've encounter another bug that leads to dinode link count
> leaking.
>
> Thanks,
> Joseph
>
> On 11/18/22 5:47 PM, Alexey Asemov (Alex/AT) via Ocfs2-devel wrote:
>> Hello,
>>
>> While diagnosing unlink hang issue, I have found an inconsistency in dinode hardlink count handling.
>>
>> If we take a look at ocfs2.h, sections below the text, we see ocfs2_set_links_count() always stores high portion of link count into dinode, but ocfs2_read_links_count() retrieves and adds high portion *only* when inode has OCFS2_INDEXED_DIR_FL flag set.
>>
>> The problem is, ocfs2_read_links_count() is used throughout all the code and not directories only. For files, OCFS2_INDEXED_DIR_FL flag is never present, so when number of hardlinks for file spills over 65535, it will be written as 65536 correctly to dinode, but then will always be read as 0 to inode due to the check. This causes wrong link count of 0 in stat() and total hang on attempt to unlink the 'parent' inode directory entry somehow (this is the issue I hit but I have not diagnosed how it happens because I stumbled on wrong link count immediately and dug that direction).
>>
>> While not sure about the internals, I suggest removing
>>
>> - if (di->i_dyn_features & cpu_to_le16(OCFS2_INDEXED_DIR_FL))
>>
>> check for the time being inside ocfs2_read_links_count() so it always reads the correct link count from dinode, be it file or directory.
>>
>> I do not see dinode link count parts used outside ocfs2.h API, so it should be semantically correct thing to do, but please someone acquainted with the logic confirm.
>>
>> KR,
>> Alex
>>
>> ---
>>
>> static inline unsigned int ocfs2_read_links_count(struct ocfs2_dinode *di)
>> {
>>          u32 nlink = le16_to_cpu(di->i_links_count);
>>          u32 hi = le16_to_cpu(di->i_links_count_hi);
>>
>>          if (di->i_dyn_features & cpu_to_le16(OCFS2_INDEXED_DIR_FL))
>>                  nlink |= (hi << OCFS2_LINKS_HI_SHIFT);
>>
>>          return nlink;
>> }
>>
>> static inline void ocfs2_set_links_count(struct ocfs2_dinode *di, u32 nlink)
>> {
>>          u16 lo, hi;
>>
>>          lo = nlink;
>>          hi = nlink >> OCFS2_LINKS_HI_SHIFT;
>>
>>          di->i_links_count = cpu_to_le16(lo);
>>          di->i_links_count_hi = cpu_to_le16(hi);
>> }
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel@oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
--------------Ab58Hx61jJyQhoN2v8iyhaJF
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p>Hello,</p>
    <p>ocfs2_link_max() relies on filesystem wide indexed directories
      flag, while ocfs2_read_links_count() relies on per-dinode flag,
      and so this is the exact inconsistency in question.</p>
    <p>I am not versed in code enough to be sure about exactly why this
      limit exists, but it seems supporting OCFS2_DX_LINK_MAX is no
      problem for the code.</p>
    <p>It's just optionally not adding high part of link count just
      seems weird to me, the field is there/zeroed even with no indexed
      dirs, so always using it feels logical.</p>
    ---<br>
    <pre><code><pre><span class="k">if</span> <span class="p">(</span><span class="n">ocfs2_supports_indexed_dirs</span><span class="p">(</span><span class="n">osb</span><span class="p">))</span>
		<span class="k">return</span> <span class="n">OCFS2_DX_LINK_MAX</span><span class="p">;</span>
	<span class="k">return</span> <span class="n">OCFS2_LINK_MAX</span><span class="p">;</span></pre></code></pre>
    <p></p>
    <div class="moz-cite-prefix">On 21.11.2022 4:31, Joseph Qi wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:911762fa-8fc2-ec01-e767-1ed8ae7e5c38@linux.alibaba.com">
      <pre class="moz-quote-pre" wrap="">Hi,

ocfs2_mknod()/ocfs2_link()/ocfs2_rename() will always check
ocfs2_link_max(), so it seems that it won't overflow.
I wonder if you've encounter another bug that leads to dinode link count
leaking.

Thanks,
Joseph

On 11/18/22 5:47 PM, Alexey Asemov (Alex/AT) via Ocfs2-devel wrote:
</pre>
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">Hello,

While diagnosing unlink hang issue, I have found an inconsistency in dinode hardlink count handling.

If we take a look at ocfs2.h, sections below the text, we see ocfs2_set_links_count() always stores high portion of link count into dinode, but ocfs2_read_links_count() retrieves and adds high portion *only* when inode has OCFS2_INDEXED_DIR_FL flag set.

The problem is, ocfs2_read_links_count() is used throughout all the code and not directories only. For files, OCFS2_INDEXED_DIR_FL flag is never present, so when number of hardlinks for file spills over 65535, it will be written as 65536 correctly to dinode, but then will always be read as 0 to inode due to the check. This causes wrong link count of 0 in stat() and total hang on attempt to unlink the 'parent' inode directory entry somehow (this is the issue I hit but I have not diagnosed how it happens because I stumbled on wrong link count immediately and dug that direction).

While not sure about the internals, I suggest removing

- if (di-&gt;i_dyn_features &amp; cpu_to_le16(OCFS2_INDEXED_DIR_FL))

check for the time being inside ocfs2_read_links_count() so it always reads the correct link count from dinode, be it file or directory.

I do not see dinode link count parts used outside ocfs2.h API, so it should be semantically correct thing to do, but please someone acquainted with the logic confirm.

KR,
Alex

---

static inline unsigned int ocfs2_read_links_count(struct ocfs2_dinode *di)
{
        u32 nlink = le16_to_cpu(di-&gt;i_links_count);
        u32 hi = le16_to_cpu(di-&gt;i_links_count_hi);

        if (di-&gt;i_dyn_features &amp; cpu_to_le16(OCFS2_INDEXED_DIR_FL))
                nlink |= (hi &lt;&lt; OCFS2_LINKS_HI_SHIFT);

        return nlink;
}

static inline void ocfs2_set_links_count(struct ocfs2_dinode *di, u32 nlink)
{
        u16 lo, hi;

        lo = nlink;
        hi = nlink &gt;&gt; OCFS2_LINKS_HI_SHIFT;

        di-&gt;i_links_count = cpu_to_le16(lo);
        di-&gt;i_links_count_hi = cpu_to_le16(hi);
}


_______________________________________________
Ocfs2-devel mailing list
<a class="moz-txt-link-abbreviated" href="mailto:Ocfs2-devel@oss.oracle.com">Ocfs2-devel@oss.oracle.com</a>
<a class="moz-txt-link-freetext" href="https://oss.oracle.com/mailman/listinfo/ocfs2-devel">https://oss.oracle.com/mailman/listinfo/ocfs2-devel</a>
</pre>
      </blockquote>
    </blockquote>
  </body>
</html>

--------------Ab58Hx61jJyQhoN2v8iyhaJF--


--===============7889007914816622528==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
--===============7889007914816622528==--

