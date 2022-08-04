Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3628CC25B06
	for <ocfs2-devel@archiver.kernel.org>; Thu,  4 Aug 2022 23:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZhYOLGzr+bmkMkllDSFkdi+yMSajJ8emGjoj9hrsoBQ=;
 b=nwhUapUnhZghVWNvo8HqsOcfVeXsCdlCexltv9ozyjvgnQrZsYpWYpVTE/2FXdYn1LbxRajOB4vW
   auxdxgK3oaGIWZtrA0ypOuFQLAWj/fYS18H40wm44KMk+LiqOkm/BkkaljuMCeuEFJp990lqYobx
   kM6ct4ltccGANIwgQllvXAyYPJWO6HvNTforA+Z3LZTTjJ8AY4J0h689XjCXD43QZzCgwDKc4Qlb
   JYcXTHxvsLkZoHh3UQRUjEnUKXgjyjkuhtqjWAgBsUm/y6OxCcfmhDSDiDzuzNAP1p2nZDwfuNdI
   ANMvhKPivzuuZ0xvaTCJwubt0zYS4HLAvMRYQw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZhYOLGzr+bmkMkllDSFkdi+yMSajJ8emGjoj9hrsoBQ=;
 b=LTmqgioi55TEYj+phlaYKjPA+bFkJzUBNJ413jk9y4KK7A/L7POFnjAQ1duXAEECpzXNPjeKAic4
   MCLwItdUeyTdE+MKl3z9wkPsPjG1Tumi0DQxh2bCtJ7szEn1Zu/jkpQf2jBPpr1CnE7pMN2giKIC
   rT2tBqVLWmuWZUmGIiwcmY3h3fCPtsBn3b+PkdHPlh42rlDAtDgUAATukIRpKK/LMha++3fJseCD
   k8/+yoqaES0g7lqOHMeziBvuuR6dw/+ltd9F0f9ac82uuQQaVf2M7FfopAP3kdW0kivTVRD4s0KJ
   EnZjiBBsAr8ygDSrK4xHKulNDyNt6kRL/d2CeA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RG400MHA7PCY450@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 04 Aug 2022 23:53:36 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fasheh-com.20210112.gappssmtp.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc; bh=Ck2+Nzo/Dq5MFLGr/NdK0ZdRxCNZNmr0VicZK/ZnP3w=;
 b=PL74p6byRpq4aNsiRWA4UpHr3uUji/8a2QVoDj8RuFwliZyFiGdVR4aZkyCIzWs1Hz
 huiHyLu+e4mTdIGUTbzx9Rndtu9zfnsOkMYqzFPfhfK0WS68xE3pDWL91A7Pam0JqRXl
 VQMqYduwQBxUF0qukOOs4IQDt34NzMCp4MgiHMFuMSnLq/wOCNFhnQb9ZwKr8wEkeBu7
 581jrlbjq+vGn1wZkOVpc+WzpXC8HjFhaxodGGBRtDzYygq4QZXEbPzLPWOqJ4f4B4mf
 rbcP2/0/R55PiBSYyYB9hZPxxGAsjyUUryxDGo2RBly4XwqJP0HEs391YbXIRWxIxoN6 9F+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=Ck2+Nzo/Dq5MFLGr/NdK0ZdRxCNZNmr0VicZK/ZnP3w=;
 b=oqdqcjUcJPgs0RDwjh0639kHMgsugU2p9ReyD8t0vRbvMM78uWtsxURgRbXH0FZfPQ
 QPX/lNDgXwlFsnHhYVUsgZtqQNrfllywTqRgxo8Wf9OzTJPN1w7MPJuzX03pjFor/6yU
 IHR1892ku7QPSsqEOCJ9tuUmytwrdrNN7qL3LcAx0XuMgDe06A7ENDffxWG2DgYgwUpQ
 fvkyrcwc+ngzIdGbQlZHdvM9PSwOlvy9hwqcGqeuKdRVB9FpB3mJNCxDELTTyqw9EbL1
 9C+JzXLu0XDiDqiYFFFc5M6p4Rqfb7H7Pb1hAVEZd4/+iL7aHtrPEqBFij+pDiae9tni F0bg==
X-Gm-Message-State: ACgBeo3K+zQT6v/O2sRjFXI3Wz78YGvuM4SdD+CKL5rwMJ2Y1QyJ/jL3
 LuHTMNvaXxT+9QQWceR/p7031ab3X91pJhuSA9wJdA==
X-Received: by 2002:a92:6f0a:0:b0:2d9:24b5:9401 with SMTP id
 k10-20020a926f0a000000b002d924b59401mr1745204ilc.89.1659657203192; Thu,
 04 Aug 2022 16:53:23 -0700 (PDT)
MIME-version: 1.0
References: <20220730011411.11214-1-heming.zhao@suse.com>
 <20220730011411.11214-4-heming.zhao@suse.com>
 <CAGe7X7kLfsUfb1+yYgD4PffnJYvJVeqrLtub8qC=ujC2gxEzTA@mail.gmail.com>
 <0b33b0c2-71dc-3961-88ee-fb29dedcc7c1@suse.com>
In-reply-to: <0b33b0c2-71dc-3961-88ee-fb29dedcc7c1@suse.com>
Date: Thu, 4 Aug 2022 16:53:12 -0700
Message-id: <CAGe7X7n7J52w3Jn5Sz5=f2AQohLMK5xK2Pjsd9oPAMSn52+SrQ@mail.gmail.com>
To: "heming.zhao@suse.com" <heming.zhao@suse.com>
X-Source-IP: 209.85.166.182
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10429
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0 malwarescore=0
 clxscore=161 mlxlogscore=999 suspectscore=0 adultscore=0 priorityscore=123
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208040099
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 3/4] re-enable
 "ocfs2: mount shared volume without ha stack"
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
From: Mark Fasheh via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Mark Fasheh <mark@fasheh.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AA6agR5dEgyjIPWTNW6PzFkVL/IpZjmIK2+1GZkQc2ErzD7GMzNbCIZbsj4QW6FNDwYm+oG1eZJrJytAAReGEYo9SRQ=
X-ServerName: mail-il1-f182.google.com
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 02de-0x3e2aF_aL5yFaQsUCSiv0QaFh1
X-Proofpoint-GUID: 02de-0x3e2aF_aL5yFaQsUCSiv0QaFh1
Reporting-Meta:
 AAHWYs5O/n/kn2lTniai2W/QrVNHitF9f5kbqbvx+YeShODulF6f5V7FYa7FV4hP
 8yyOXNWRnnPpmjkvXDNXwya51CGneDy96h1O5oXqGQGWgxVqtNxOcqHkB3mx5LUP
 37zmgO+AZR24c0Cz4MZSGE9MhsP7lAgvHLKbiQEnc066/9vo44WLpoWpir/bKAx1
 LxzsAhn+IRBNs6aMX1n16cfVCldx/ZpUozAZZBUXxUfk/PfZQ0bbonCEVks5H7Mg
 yc3NhkVGWYwsTpZmQ3M/VDFiBwo+d7CNdtOr548NOoB2OUgazlhYk0CqCVU+TtgB
 iWNxHXoeKQw3Pb715GPFDrekIpM/U7I7qNP3lOaH/7qK1ZMD6XgHrYzmRb3QOSz0
 harHqUGBDI3xkp9q2M1XNJXSp5dYJRTW9P0UbdY2v77icyk+PSnUrp/M3RrCfBpT
 6p/ss6bShtgVd8uhzfi7Wuibt15ZQ1iyP8R0+X/k6leykMrLf1QS35Zm5NAGxKJ0
 qNRAw1/BQclvhmB2efHe9VnG8kTQjW2D0sktCyPGrjw=

Hi Heming,

On Sun, Jul 31, 2022 at 6:02 PM heming.zhao@suse.com
<heming.zhao@suse.com> wrote:
>
> Hello Mark,
>
> On 8/1/22 01:42, Mark Fasheh wrote:
> > Hi Heming,
> >
> > On Fri, Jul 29, 2022 at 6:15 PM Heming Zhao via Ocfs2-devel
> > <ocfs2-devel@oss.oracle.com> wrote:
> >>
> >> the key different between local mount and non-clustered mount:
> >> local mount feature (tunefs.ocfs2 --fs-features=[no]local) can't do
> >> convert job without ha stack. non-clustered mount feature can run
> >> totally without ha stack.
> >
> > Can you please elaborate on this? Local mounts can run without a
> > cluster stack so I don't see the difference there. We have
>
> I am using pacemaker cluster stack. In my env, the trouble of the converting between
> local and clustered mounts are only happening on cluster stack.
>
> the non-clustered mount feature (Gang He commit: 912f655d78c5) gave ocfs2 the ability
> to mount volume at any env (with/without cluster stack).
> The 912f655d78c5 derived from SUSE customer complain: User wanted to fsck the backup
> ocfs2 volume in non-clustered env. They wanted to access the volume quickly and didn't
> want to take time/resource to set up HA stack. (by the way, pcmk stack at least needs
> two nodes to set up a cluster.)

Ok. I had some time to look over the ext4 mmp patches. I feel like
there are two questions here:

1) Is MMP a useful feature for Ocfs2

My answer is yes absolutely, the user should have the option to enable
this on local mounts.


2) Should we allow the user to bypass our cluster checks?

On this question I'm still a 'no'. I simply haven't seen enough
evidence to warrant such a drastic change in policy. Allowing it via
mount option too just feels extremely error-prone. I think we need to
explore alternative avenues to help
ing the user out here. As you noted in your followup, a single node
config is entirely possible in pacemaker (I've run that config
myself). Why not provide an easy way for the user to drop down to that
sort of a config? I know that's kind
of pushing responsibility for this to the cluster stack, but that's
where it belongs in the first place.

Another option might be an 'observer mode' mount, where the node
participates in the cluster (and the file system locking) but purely
in a read-only fashion.


> > tunefs.ocfs2 look for and join the cluster so as to avoid corrupting
> > users data - that's a feature, not a bug. So what I'm seeing here is
> > just opening us to potential corruptions. Is there a specific use case
> > here that you're trying to account for? Are you fixing a particular
> > bug?
> >
>
> Tunefs.ocfs2 still needs HA/dlm stack to protect joining action. commit 912f655d78c5
> works on non-clustered env, which needs other tech (eg. MMP) to protect corrupting.

FWIW, I'm glad that we pulled commit 912f655d78c5 and I do not think
we should go back to that paradigm.


>  From my viewpoint, the non-clustered mount code is based on local mount code,
> which gives more flexible than local mount. non-clustered mount uses unify mount
> style align with clustered mount. I think users will like more to use non-clustered
> mount than using tunefs.ocfs2 to change mount type.

Can we get rid of the mount option, and make mmp something that users
can turn on for Ocfs2 local mounts? I don't recall if we make a slot
map for local mounts or not but it wouldn't be difficult to add that.

Btw, thank you very much for all of these patches, and also thank you
for the very detailed test cases in your initial email. I'll try to
give the actual code a review as well.

Thanks,
  --Mark

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
