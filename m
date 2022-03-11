Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 454EEC433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 11 Mar 2022 01:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WH+mit9z5eP+/LQEjGGtfWmrtNP5wlFvvjzwmx4Hkhw=;
 b=hr5Dy3UxukK47m0yifQjtL2SIYlT9RsGc85eBsA+AfUPh2mM0mcIbBJmDznWqqSPogV2reIGN4vj
   S+4KA5V9TEZHA1Ldh83I2IBsg4qiWSfkwliI7pizqO9VUPFTig9FB5xgYGN5UvH9149cFNS6AdmV
   FSdDZITu/SHKn21srC3tJyxbz0X+WPOjB9YOtr02aEIsxetxp7xGM8G7vyVqbx4i+p5rEu4xunfX
   nBhvv6Miq6hRL6r/eDytVwtitiU5BeYnrltS1NFFGUGP5Hilf66XZclzVUQvBFSsNCZKjvIkoino
   P3HXdN7IFEs6zIfdP68N4JwMTdgGY5L1CjAgfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WH+mit9z5eP+/LQEjGGtfWmrtNP5wlFvvjzwmx4Hkhw=;
 b=RFPQuu2yi82ln+ZzoO1qvz4DUEE5uUHCiN+Cce6Lx5RYLO91QqYnGD8gePaOIoeGvMVwxb8Y5Gup
   KzV5WD+dKylinfZ7EBXXb72D5Fe3qRHJ1eiO2HmyKgRFIaHuCNfjz5DnaBHJ+JzsYC51Wci4TE+h
   TtWEiSE8R5kUjr7ibzVbhrWfhbzn51cICNPHfJ1ZqZbo+AVFkGtGOrfWzTMuA3Ba1Jtnu5wg0mfy
   hSapYiZ1bmXfuje3/WsIK4uCyFHA+2UEsBUCUoKASblED+eOH3BY6SFpGaWg7Ohv+MZULYKpDkDc
   sLwC2/iQq1/OsmqsilQwa5P6uRp3ykrA7iV+aA==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R8K00PVR55H4J20@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 11 Mar 2022 01:51:17 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=jiangqi903@gmail.com; dkim=pass header.s=20210112
 header.d=gmail.com; dmarc=pass header.from=gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=message-id:date:mime-version:user-agent:subject:content-language:to
 :cc:references:from:in-reply-to:content-transfer-encoding;
 bh=I59TzbVql0ag28Nl6BA7VynDuVK8VqOqL+VyBH0ld6k=;
 b=P3DLvmb3Dv4xANRXZLqqE2yAmAy3EN/w+7UPzBBJM+UZY+CzFp+pwao5IOJNey1G0t
 xdDvuExqpgedjnC5KQk/X1OR4B5f/aSAVj9fdHcta18pRBC0K9S1I2xWcywEe7hk0uBs
 XMA3RA+G1WQTt2VH06VI3rsT8cuLHqjSCoZsmrSSqiu5HdCX4fcE3PixwgXJlrg+Ct84
 aAjF5ztFkohYdOtz24+J/koXYULtHwFO3Io9NHq7mwN214vdACG3I+WPvT7shJdO3OF9
 CN2kIO8x3XJlkk9GQnoOlK8FGYBkkVZcyyt24vj0WHhVmz/whV7wizsF/lOEMOWqo7Ll u74A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding; bh=I59TzbVql0ag28Nl6BA7VynDuVK8VqOqL+VyBH0ld6k=;
 b=0C73MdsLKIdhAtf6Jk/1IpcYZZOvN/xch3yqyndEPhj3dHDa5pt7J9sZkCKyRFJoB7
 EDCFLiaI5Pft0CqFHbWSqYUt9Tz5ir3D/gvRoWSuySZ/5bvNpOfs6Br3+7c436F1aes+
 /MEc3rDOa0Pfo523o+ppD0QAkUdAz4Trps3ifEPZvrk5TpHg5/fXHbXZdaFyrHET9yeF
 qJTWRTtrouAOO2zVdTh9FuNgpVBnvO5MqVwR6O+Yp1F0kAeZIgXZYy4hhz3iP03jkKn9
 zIfmPgN3G+W3nM6yqK8c07s0b9Zg/SXrBeVT05UIYrAH8Y4VGt5a1m+D6Tu48tbDV2iQ fkoA==
X-Gm-Message-State: AOAM533zO+sR2ON6tU3nODPe8dq1rUaNNDOh5wrLEbYAPXmKPpv2jWy2
 iaG5yxvDd8lBJr/miJKv6gc=
X-Received: by 2002:a17:90a:bf8f:b0:1bc:4ae6:e009 with SMTP id
 d15-20020a17090abf8f00b001bc4ae6e009mr8116182pjs.127.1646963462980; Thu,
 10 Mar 2022 17:51:02 -0800 (PST)
Message-id: <eecb818a-538a-0201-c3f1-19d7c36b8dff@gmail.com>
Date: Fri, 11 Mar 2022 09:50:59 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Content-language: en-US
To: Dan Carpenter <dan.carpenter@oracle.com>,
 Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20220307145138.GA22641@kili>
 <82b26a4a-2351-f2b3-dd7c-265308e6b384@gmail.com> <20220309145717.GX3315@kadam>
 <5a5933bb-3078-2cfa-9403-a6b497199449@linux.alibaba.com>
 <20220310133918.GH3315@kadam>
In-reply-to: <20220310133918.GH3315@kadam>
X-Source-IP: 209.85.216.53
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10282
 signatures=692556
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 spamscore=0
 clxscore=161 priorityscore=333 impostorscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203110008 domainage_hfrom=9707
Cc: Jakob Koschel <jakobkoschel@gmail.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [bug report] ocfs2/dlm: Fix race in adding/removing
 lockres' to/from the tracking list
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
 ABdhPJzBeJ6OG8qrpbwg6H/k2Svpjuk3theRnLc/Ka6a7/14fGxWkb3N2LddmZ2FO7ec4EAHkT6CkQ==
X-ServerName: mail-pj1-f53.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-ORIG-GUID: CapPHgZYcuf7aEAtBtRJWnqZijriMXsq
X-Proofpoint-GUID: CapPHgZYcuf7aEAtBtRJWnqZijriMXsq
Reporting-Meta:
 AAGoSkGwZUgi2Xhkd0ZdmL6LbWKuIrvYd+a1AJZVOdjn9EnTCe70ilcJucuaJ9iY
 EDfw5bbkrAsANnHZBGfm8mVLLcyX5PFUN+ov0WDtKhpoJocY2zn4snSiro/luBAR
 VQGzNPAOiZaD+PRrep6qOt7ys06BuIR9as9NmeggKbII/Ax2s9UWtuxPbMQUc/vi
 a/gq71MHrkguP2VRNj+LlBQ7RRi+21MpV++DctIm2aspq4biHj8f+c+rJu+yyp7f
 ja4gKKBv1BS0Jc34E+j+M2eMkhQlrGTDdtaFMZEquHLtpP3JlQNLkq92lWvnOl6z
 BBlWyurZMoQ9F4Xh0ONEJqxw/sAKTh/8WHFWSf2rUmU9oumYkrVgNaZzAphP2OAE
 noZjm+K2mcnZfQCMUxNobKX6H4BQ0k1xB48QAgAkodidcZbnghe1Cim8Vwg1OoHS
 qDeBv+Jtw584AP5A+xLQg1czNOTaMJpsfpP57OKze1QPlZJtBXs+HupjKHnSQRsQ
 7y2jL/oAgG0Dxti9eWt8zBfM/GocM3ZAicKLCcYypcw=



On 3/10/22 9:39 PM, Dan Carpenter wrote:
> On Thu, Mar 10, 2022 at 11:13:05AM +0800, Joseph Qi wrote:
>>>>>     557         }
>>>>>     558 
>>>>>     559         list_for_each_entry(res, track_list, tracking) {
>>>>>     560                 if (&res->tracking == &dlm->tracking_list)
>>>>>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>>> This should never be possible.  How is it possible?  If
>>>>> &dlm->tracking_list is the list head the it's not possible without
>>>>> memory corruption.  If &oldres->tracking is the list head then I do not
>>>>> see how it is possible without memory corruption.  We can't mix different
>>>>> types of list entries on the same list head?>
>>>> In case of oldres, and the iterator points to dlm_ctxt.
>>>> In this case, the lockres is not a valid one.
>>>
>>> That doesn't make sense.  :/  This condition is doing pointer math.
>>> The offset of ->tracking is 136 bytes and ->tracking list is 88 bytes
>>> into the dlm struct.
>>>
>> Now track_list is oldres->tracking, which is already linked to
>> dlm->tracking_list?
> 
> Are you saying or are you guessing?  :P
> 
Honestly speaking, since these are debug code and not used often,
I'm not quite sure it's the case described above.
I'll dig it more later.

> It's not impossible to set this condition up so that it's true.  But
> it's bug if someone does that.
> 
> I really think that condition can be deleted.  If you look at the commit
> which added it b0d4f817ba5d ("ocfs2/dlm: Fix race in adding/removing
> lockres' to/from the tracking list") the it's easy to imagine that it
> was a copy and pasted pasted by mistake.
> You may test your changes simply by:
mkfs.ocfs2 -b 4k -C 1M -T datafiles /dev/vdc
mount /dev/vdc /mnt/ocfs2
cat /sys/kernel/debug/o2dlm/<domain>/locking_state

Thanks,
Joseph

> Or another possibility is that it was debug code that was committed
> accidentally.  After all if you remove the locking a delete the last
> entry at the right time then it would be easy enough for the condition
> to be true.  Hopefully, these days the locking prevents that condition
> from being possible.
> 
> regards,
> dan carpenter

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
