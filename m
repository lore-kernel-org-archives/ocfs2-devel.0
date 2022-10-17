Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E194C433FE
	for <ocfs2-devel@archiver.kernel.org>; Mon, 17 Oct 2022 01:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EvqHDNbKRu5elLpGSJk0JUt2wBMz+rm03oMTRaS/dCQ=;
 b=LlFmak7UWGbm3hUa9lNfTwPEJE6fbxLz0ZfJNXP/Twnyf70HQwJe71d+603k/nKKrjUlT6D6+SxO
   3y2BGV3eSurOlgRRtsjUp9VIqI+glaynZiI4pcxv4kn54SViqCRzS/Z6RiN/+w6oARC6M+vbBZir
   kvJTXxSbzfCp6bKXbOVUMH+/i4r993KlyjGGePbCCjIKswj2WKtsE5w3Vq+6CbjGUHrpUL60kLWv
   Vd7xoo6nf73lOXDILqerkuWJDsm/54lMVP/+RSGcs/VKB+KZJcEHHePT6INDtHf27BaRgQuG6RHa
   JG9Pk+hfDdkZeJ12rquNgYsz6nR7wLpbLo82AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EvqHDNbKRu5elLpGSJk0JUt2wBMz+rm03oMTRaS/dCQ=;
 b=AQmUpns596nY0oiNUF4P4qBxwviUVt4YOBJUdQwzL+XBUBmpg+5L51HvSPAcfZszZcjqk6qqyN3J
   IXQBsWpdXru1OhrnbZlIZ6fcsmedZ66otym85kadgOzCdwojQoVGXYjk5doQ0rWFmQwvMOdS1MxP
   mgvku1rAKkqvu1q+GAn9MPzmzlAzOjo/afD5dolHQfwa/d7bKZlkOlzq6iN2ManC+hv28uN92l6e
   7EaHGBbYSP8BgkVUh7fUFBi24PNbC0OQRHrbfnoK0MZpSwDxWs0+rVXSdgiYV3owBQqB3UWTMkBk
   R5PwJdiWWDx0xpyPJucCitrj37lUOSh9zNKDYA==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RJV00LO6K4T2C40@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 17 Oct 2022 01:58:05 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=LNExlwGQANOjTBQ61Dl22tAmqPeAyvnrePSDfHfC6oM=;
 b=RFua4eJ7qOtEq6mCUtNP7yNQ+6bDeyDHrH1w2RMwXnJVfIPzW64B/hSgwpv0HmZifc
 xncBTOEapE8NRGreGPMbcRryvliqGqvpZJXzpsr5MahixzSEtmWvAkRBuV1ow4Gi3AhD
 b1zLdE8z0mtuvX6PAx+gChCnN9lNdRu0RyiESDvacQBF8BMCel4PoszJ2B9qGAFDIrn0
 qLfq0bNmyZh+3tUCblUmJt/fmhhLgeJgkmub9bI+Nc7IxUSzCvZtxF8jzmoI4pGEwfMJ
 ZCC4ShEWFD/TWDcWbPehS3XX6W16PyiGiFPcsHBmNoeNLbSsGDhhFBTVCux0QOLLslsN 0+aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=content-transfer-encoding:in-reply-to:from:references:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=LNExlwGQANOjTBQ61Dl22tAmqPeAyvnrePSDfHfC6oM=;
 b=ZnC75I7TELHR1ts8qlFnFSxijphdW+xlV6Oi0uuNeAdY9tublb/ackLjzi0gxBut7O
 xb66m3tAcbsgaIn636bs4nrwSsQ2OUNOdrrepWnw5CyUhQemzgyDSAjrXImqWIGe5D+u
 MwGGmuiUcXedYHgjIuMCk0o6E05evfLrlODJNW8r7p0ZymvgN6VHFGKbV9t+qo7b0LYR
 IXb0O1r4dSFkPD7DjYSq5mU9Wx2HGLyv8ameNFkkMRk/X9d99GPlfFcwyYlc7TvZoDGw
 OQnEJ5e0SbeJn3UgptuCeQgkk7Yx2ak+Bs6RBATkgBLO6PWs7g9v9cv4VgesK0IPolyl PFSA==
X-Gm-Message-State: ACrzQf1+isLLTpyN9l4nR5vcYkLtHhWZHDk1i+ekPfj5JhYGhsOhDqLC
 QkVjR9ves6BvxZQXT32xRVc=
X-Received: by 2002:a17:90b:1891:b0:20a:daaf:75e0 with SMTP id
 mn17-20020a17090b189100b0020adaaf75e0mr30354674pjb.109.1665971868691; Sun,
 16 Oct 2022 18:57:48 -0700 (PDT)
Message-id: <8d6c14b7-8224-4637-73c8-08f427095588@gmail.com>
Date: Mon, 17 Oct 2022 09:57:45 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
Content-language: en-US
To: Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@oss.oracle.com,
 Wangyan <wangyan122@huawei.com>
References: <d8147c41-fb2b-bdf7-b660-1f3c8448c33f@huawei.com>
 <09b83918-89aa-2f5c-bbbf-ea4470386bfe@gmail.com>
 <20200806204910.6fa489d7aabd5c8026f4c704@linux-foundation.org>
 <20221016163245.786bb7ee9d6cfc952f445642@linux-foundation.org>
In-reply-to: <20221016163245.786bb7ee9d6cfc952f445642@linux-foundation.org>
X-Source-IP: 209.85.214.176
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10502
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=34
 phishscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=952 impostorscore=0
 adultscore=0 spamscore=0 unknownsenderscore=20 suspectscore=0
 priorityscore=330 mlxscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2209130000 definitions=main-2210170009
 domainage_hfrom=9927
Subject: Re: [Ocfs2-devel] [PATCH 1/2] ocfs2: clear links count in
 ocfs2_mknod() if an error occurs
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <jiangqi903@gmail.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AMsMyM6v3CvoUwPBx4n9B6oga3LmlySF+nS7srw+8kK5AraJ+n+WOeZGm7MoVf1KURAtWajw6pW9mQ==
X-ServerName: mail-pl1-f176.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-ORIG-GUID: juOoMGftJcqfL44Mo4TmPNJ8nyObiT4b
X-Proofpoint-GUID: juOoMGftJcqfL44Mo4TmPNJ8nyObiT4b
Reporting-Meta:
 AAED4nrbuwIfgcdkMsiMDUHwaoMPNW3dmpTwXUib7or+PMpTjcfZCFDdW7bYaGOS
 IdX/APpPYoXNVJ/rSa6eyvcgTjJQ6SeXQ35bfBtBbmm2hFH39DsYqWhppfs3wmul
 VCUFsaDg0Cz0yB7XAEjfZAoKIN8CphUpetfWCR8KRV1AotPB7Pmn6/zpQm39hjeA
 Gjsa+aqPbech1jOEsoZsu0udDTIJAECJEU9Y6x9Zzj8biCRPJoAU/PonwkRhbEH7
 EwxmsuNL0UjJrQ9eORjZQZKKip+J6IyEGgtNORmziAAfr1kCOBOVXHdzlGqjiVr9
 qSrRja0Ag6jIdrxxSosDobGbKHGKem9qKoN/7yZBWlXkUGxCqQgUZuObeRqCwNmO
 OKwbEDtKqJa+J/pdRBm8+ZFdrdGddn4E5Pzs/nqJAw3kUP39DDdhXwh0IQCPtXR3
 XO0iGUgd7jA6pQfAvIKw3xYqlAj8L4+WnOba8vkLW2GAP5zsDZLH/IWp3yvwH/Hu
 xt8YVK4aVzJ+TN/srwYvtaU6j6y5xzI8028oOPkHwiYU

Hi Andrew,

On 10/17/22 7:32 AM, Andrew Morton wrote:
> 
> I've been sitting on this patch series for over two years!  I assume
> the problem isn't terribly serious.
> 
> Can we please come to a decision on how to proceed?  Thanks.
> 
> The current patches from the mm tree are below.
> 
It seems I commented before, but without any response.
I'll take a look and send a new version base on the latest base today.

Thanks,
Joseph


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
