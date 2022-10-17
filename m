Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5D51C433FE
	for <ocfs2-devel@archiver.kernel.org>; Mon, 17 Oct 2022 01:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=DxMeK+gdem0YdjIWdLdLDS6EqA5FXsb6DM/HDonpJaQ=;
 b=goJDB7aTfRgguApSuEclo4AGFgE6xvK4vIk9HLlrH4v06fuHuKpg/R4qzCi7s3gWpWR+dbiQcrOP
   62l/H0YL2RkhxrLy4LygAy/PIVwAVYVo7R7/WboWpePO5YIeaowU4HUi4QDSFn9j3EsSGyp166n7
   bwzRp79u/mxh+eQIx7eYAloXkopThOPz/9ei2yAkm4Wllu+S+KWzl5Q3VJncWLqKL5WFQmuiq6eM
   EZzMkVLX7KV7CsrY/adS0dcHJPu2pFYSPVALbXZmgvy/DBp9Pst2BrEAfJfTOWvH89WlW2XbB5Lr
   VP9sQYf6H3/mf7Fz8cJ5hwXTBaIzEdjfNLvd2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=DxMeK+gdem0YdjIWdLdLDS6EqA5FXsb6DM/HDonpJaQ=;
 b=sxu8MFJMBhYNI2Wa3KAGsY6z7SxMBT0kaNWbEgR5Js7WNMoCvnJzgs6/VeDJMvUzquFgg0pHoso8
   0ZczFJEKv1HIfmOEZwwfKVYVa7ZVpA7BwmFYf+NCDhdDJoiacktXY2xmstXIh97+jRUSegIfm3j+
   tj6dxQyf1bpueEL0Y0bDaaeyEex4i/cp+kJy6TW9rCjQmezXPhHvlLHQ6JMogmjy5EA+nGNda3rl
   +apipDLqdAPd+T1a4aq7lnJYbIo44QVhButjjQnoaec6BhToWUlZ3OWcVJpwfLD3vln06QkJ2seE
   rDIAHpGusHHgGi35Z9nmBOknyZP6I0ve7imHuw==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RJV005TKJTWAR30@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 17 Oct 2022 01:51:32 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=O0u2/qB79DDSymMhjMNmMe7kf6mNO0BFvgwh+ZdNdWY=;
 b=i29c64fcZ385P5gN/bC6pCEuW/uWOjN5BMPnSv425TTet9kAcW62+87LRLwptVNfSm
 bL7KHV4KC8OvnT0u7OQ2flB6V4B90PANDqtW0kDul6OnfUOtbwQUn7eF1J7PMguHOMED
 sYP4INZwaDGFeQ7idPAGnusGuhqiCJortJUIvJdDH+Ol9pOxw/l8d7qdBAiGRBdHrIpr
 26CvZEYx59N2Pu8/Tp9G5Wn/6/9eq2FqYlzx4LqhBfxZwGyzO1TMrisTKuaLwERlLQxA
 EErCBNGsG2ILHEJk6lW8WPKKm/gw/wGoOtMEi7NsPA4eJwNYhHojQxkhQYY9iZEHjb1X Mtjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=O0u2/qB79DDSymMhjMNmMe7kf6mNO0BFvgwh+ZdNdWY=;
 b=HPcYhCHPxkuQhln9xUMrMTwh1z00eXB5Eqr7/vJYpOouICQY1cimwGEzrGyY8RMH73
 lArVKd0r5CclNGH1I9do/jrsR+AnfBWCWP63sAZucDbtDAg/1sCKd0fUn7gDcAYO6w8F
 wenRQYBnSHK83fmL27C90MiVUbbsHoD+HcqdXMir076fW2MYDetxo5EaB2/1oW3e7/im
 kufxfpnuZhqRPhd/ZROsT5IVWTTvR/bybfg62I0WQiErlwXHvPHbpr7J2gD4/noPYrXR
 m0EXskUo1YrCnb7B8fQxTFGK89ORONmHUxtZ1+y6gl9KFYcZW+/FwNPgFmMZZrfMQ0mn Q+QQ==
X-Gm-Message-State: ACrzQf3FpY6P0SkUeYbZD+OqY0GdK4vhHFdiKfcf0LPPR5xHwr8oNfxO
 p5q1Rz/A+EEXHxAukSVppZs=
X-Received: by 2002:a63:d512:0:b0:46a:ff05:ce8c with SMTP id
 c18-20020a63d512000000b0046aff05ce8cmr8876870pgg.292.1665971478234; Sun,
 16 Oct 2022 18:51:18 -0700 (PDT)
Message-id: <06a7f382-5eaa-9489-3c28-aa4bfb804327@gmail.com>
Date: Mon, 17 Oct 2022 09:51:14 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
To: Andrew Morton <akpm@linux-foundation.org>, Gang He <ghe@suse.com>
References: <20210729110230.18983-1-ghe@suse.com>
 <5821fd0f-2018-dc1b-a5c0-f948a7debff4@linux.alibaba.com>
 <c7e1f0a7-e75c-d1e0-870d-dc480d070079@suse.com>
 <71608a14-58f4-dba0-d695-fee65de89192@linux.alibaba.com>
 <801438f5-655a-c708-aa25-343d54a2f11e@suse.com>
 <86e3d724-3147-ccaa-998f-0f857c575f7e@linux.alibaba.com>
 <a0a9710f-461a-99c8-92f6-a99bb11b3a4e@suse.com>
 <4ba3b404-824b-90a3-ef43-9ab6510ee073@linux.alibaba.com>
 <5a1af56c-3eab-5baf-62a3-1c98bac104ba@suse.com>
 <db7119a5-f120-cebe-42a1-dc2f64db620d@suse.com>
 <20221016162950.09db2b5f503ac87823cd1687@linux-foundation.org>
Content-language: en-US
In-reply-to: <20221016162950.09db2b5f503ac87823cd1687@linux-foundation.org>
X-Source-IP: 209.85.215.175
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10502
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 unknownsenderscore=20
 impostorscore=0 mlxlogscore=589 spamscore=0 mlxscore=0 adultscore=0
 phishscore=0 bulkscore=0 clxscore=62 priorityscore=293 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210170009 domainage_hfrom=9927
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: reflink deadlock when clone file to
 the same directory simultaneously
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
 AMsMyM5vViC/nHuZEYX6WRA8n+EnpFuattZzIjESrObM8WLhJB5lqRBuOhsJkd46jBXsztGXBam/LQ==
X-ServerName: mail-pg1-f175.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-ORIG-GUID: vOGBXXork8ZVwSOYOlatmjyYi4s5SU9_
X-Proofpoint-GUID: vOGBXXork8ZVwSOYOlatmjyYi4s5SU9_
Reporting-Meta:
 AAEF4MOjAXWlNUXt9BH0fA9Y6YIG8+WZ2lbxUKEweu0381nZrq79t0oi1sWfTpb1
 SS1Ho4CQ3ZO8+AkFwwPXmWNqWn2wiAIKgD/FXjrER8xm9rCg6Z71P/F/7XlsmeSe
 0eFAgNtJu5AHNC266iIuWsyWnFrvQ5NpSwapKryNkKewm3eYXfflLQuFPOPhkV10
 utkR94qVZd7Gr0rxJr8GwmT7eUS29YH2mNi9bUbT4bypcolocA4zy58v5jblb7dY
 wntNAmVNIvMhnOmKiv576gqpPt71KmP7Pocxr+kHrNd7+tEBGpLCFuJUjD2bPMxJ
 qYvqX5OPBQ2Mh7pD3ZxKI/UELUF3yFzxaCbcYpoG3Sp7h8YdnNgNGvS+kjnGrmc4
 J1PF3tHbs9KBCoKZUSZrO/Mpk8J7Gobis+BAr5SL1+LelN+v/abbJYU9O6g7Vicv
 aWsiUXrraN+xVtlZoq80reRly20333EXZmOlEJU/nKb2rVqO+aWa4neTQlA8Xjut
 gTvN8RsvjM4rnI6IF1zbmYEqrcrFOMfaAtOT5UAklHS3

Hi Andrew,

On 10/17/22 7:29 AM, Andrew Morton via Ocfs2-devel wrote:
> On Thu, 26 Aug 2021 13:56:16 +0800 Gang He <ghe@suse.com> wrote:
> 
>> So, I will send a new patch to fix this deadlock problem via dlmglue layer.
>> For this patch, I want to change the patch comments as a reflink 
>> improvement patch.
> 
> Did this ever happen?  I've been sitting on this patch for ages.
> 
Looked back this thread, the root cause of deadlock seems to be the
asynchronous of fsdlm handling. So this is not a right fix.
While for the performance improvement, I need some test data as well.

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
