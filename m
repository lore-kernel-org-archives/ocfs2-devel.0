Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 202F2ECAAD4
	for <ocfs2-devel@archiver.kernel.org>; Sat,  3 Sep 2022 05:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FTv612nCRgv+id5FRUrUZrCIGHe56lSRUrx3/p7737k=;
 b=I8lh0GJKGmSc84k3j5YtfI2WdQZuC5QEXvqSuo+faPtaq5EB1XgVPqEoIue+2IjRnzCOfo9SrMAP
   h6CzvNu6Uu++fDpFmQgoNa2HYWqwRd5vc4ROC5OrDliZfzWRIqdgxxnCej0QcCfOVXAJ3/ZcdK6S
   O1vYryDFGdv59scT2EyR27f3A/W45CbxfP3y6bsZCsrHpmKknp4zFjjTBxHT/G3YV1BYauCxG5sF
   8NRqobcpLb/BH1r6ynbLADasrjyreC5wDc06TVfpL59Reg65nfAWIpX5Odzr0b0kWAD4eIGugU5o
   B5YkPXWFtP0rtjErDcy0/jc5jfF28Uo88mZrng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FTv612nCRgv+id5FRUrUZrCIGHe56lSRUrx3/p7737k=;
 b=S9+qQJAKYPt8qDG6os64LBNI48sWrbJ0p6tzP/9fuN46klncvrewd0s0aPYMTq4sWXi/GEMvMHRR
   eQ32Zss7nK8JeegzVA3KtAXeK2KahRmVqjbtsZd97JaqhgsZCguiyioaBV2eG4VcIR5IhDP7fBG+
   f0JiDD/LcoezJcgCUZ/usNW0rACk7ANyAiX5GzZDQsDcafQqAVO7MuQ6T8imSjQYSor3Cx21sPEW
   AijrIoHrjgWN9i3u9f4miB5AyfOWdTOVyZgoN4QHOhlFfkKsRWjhdvzcE/9xD/T+p+7xtLWcyiCH
   ARBF3HTk5RcuQA013Z7Eh5zhSxWNwukRKmVM0g==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHM00JNRBT5Y5A0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 03 Sep 2022 05:12:41 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=DWQU4BjAk2RKJXcziV8gz7Em/gw7x1iBMRQeoGw/K1A=;
 b=a0Jq0XZYSQA1ZyBSSQtFq3BQ8vg873jp0dp5wazzJ6inOF195+lnsDAOPUGs6u3Knz
 z1zC7iYuExltCbr1CHrw+kG2wIrjr5zrW75GFzxfyyLEKJZmUAz4MkHYLh2c5VL0y9UD
 aqsiJxsNXtVG4DXUTWfcxZLABqciAZKarEbtI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=DWQU4BjAk2RKJXcziV8gz7Em/gw7x1iBMRQeoGw/K1A=;
 b=TgWQWEbzwivbnPdd4CNphhg77HBeXuifwS2tzDtjzvrsrti+fSNQdFML8R7m8AnyCV
 mbvhok5iZ8EBZzUccJfer8ZtYkFYIskOwks33YG8lihbIQfJnsf1ujMEcf92dip0clhS
 Eg19tTwDvQPgkDP4A9vOg1ofmNAXR3GT606NRexwMP6ZLTLcZjy56wqSTJVt/wQm76io
 yDYYI0A4RR8Jh9LVBBBOdrOEoGi+qH6s9aC+FpjlIa/PBcglpOEKWq7/5NyXYevnfJtO
 z9DjJptVtgIeqnWBFM+LHf6WSFfzz9Q3n8OK+pAwsa9lgrbjd8KmeFOgUnR5BH+J6Jd9 H0Hw==
X-Gm-Message-State: ACgBeo0DOBIk/Os3paEAOn7cro+qTDoS5vUEZMUJnEaIRZDLt+++mGqk
 rqb7MrVCPea1Fu3zSdXnfa2vYQ==
X-Received: by 2002:a17:902:8ec6:b0:172:dc2c:306d with SMTP id
 x6-20020a1709028ec600b00172dc2c306dmr39278791plo.104.1662181947281; Fri,
 02 Sep 2022 22:12:27 -0700 (PDT)
Date: Fri, 2 Sep 2022 22:12:25 -0700
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Message-id: <202209022212.7F753284@keescook>
References: <YxKY6O2hmdwNh8r8@work>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <YxKY6O2hmdwNh8r8@work>
X-Source-IP: 209.85.214.173
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10458
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 bulkscore=0 adultscore=0 spamscore=0 clxscore=19 malwarescore=0 phishscore=0
 mlxlogscore=766 priorityscore=243 mlxscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209030026
Cc: linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH][next] ocfs2: Replace zero-length arrays with
 DECLARE_FLEX_ARRAY() helper
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
From: Kees Cook via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Kees Cook <keescook@chromium.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AA6agR79orMmne040IWFGp4YWTLDIAXoo56UMa3pGaPPoHU65ls6cjvq+KJexvX/CPOzSvzjZEMf7g==
X-ServerName: mail-pl1-f173.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.google.com ?all
X-Spam: Clean
X-Proofpoint-GUID: iir9R3cnnNd6DhAqqzidk17CVSpdFLgC
X-Proofpoint-ORIG-GUID: iir9R3cnnNd6DhAqqzidk17CVSpdFLgC
Reporting-Meta:
 AAG4Gx31oGzP26T4QqFe4KjVK0a2FB419Mpbm9LSfbwIxBB8usF9sZbGwgm26Wj+
 bX5Jy5BlLluBdtseFi32+Ou0iGOUv8RkVI2Dup5xbL9BJgZp51mV5FGK7DnHvaKm
 YqO48MOtR8Nu1Oc8uOh2IQ67N7J9LFyzr9u3iY6WgT4To0vZNMXClirwb6Z+F9Iu
 1/mlz8cYY4OBtfAItrzStC+W+bsdbdc7hKAS3r+QRttxo4GNjUeX4ZqN3t73yXd/
 tMvOxWESRxOJ9QOoqSqFegFpHp0qvugnmyetOA6f/tfGgm8lAeOzcc4vzQ/Y75Dr
 O8+sAnggaVpQLd2MufCVCSwssJlYcjHx0l9Xn7wUvD21Tuw3gypmHwfJv7BbQb/l
 ML4bgVuckpKxaLSr9CaOPM09RpofoprBUHAMGrqc2TdNOPaEsekdxJZmjITFAJtB
 +zn5RUmlfOsmjgCIpstR0z3MqkHoovYDsa+M1+ZSufwnCtfuPrsvq1EvquYtFU/2
 baU+oxAJUG+Hm02H+MRuwgQdKqpvK8SL6iaaAp14aTG+

On Sat, Sep 03, 2022 at 12:59:36AM +0100, Gustavo A. R. Silva wrote:
> Zero-length arrays are deprecated and we are moving towards adopting
> C99 flexible-array members, instead. So, replace zero-length array
> declarations in a couple of structures and unions with the new
> DECLARE_FLEX_ARRAY() helper macro.
> 
> This helper allows for a flexible-array member in a union and as
> only member in a structure.
> 
> Also, this addresses multiple warnings reported when building with
> Clang-15 and -Wzero-length-array.
> 
> Lastly, this will also help memcpy (in a coming hardening update)
> execute proper bounds-checking on variable length object i_symlink
> at fs/ocfs2/namei.c:1973:
> 
> fs/ocfs2/namei.c:
> 1973                 memcpy((char *) fe->id2.i_symlink, symname, l);
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/193
> Link: https://github.com/KSPP/linux/issues/197
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
