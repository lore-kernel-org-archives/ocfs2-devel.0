Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5DC4C00140
	for <ocfs2-devel@archiver.kernel.org>; Fri,  5 Aug 2022 04:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Dyrof4rhxxz4dTYsosS6+CL1fmPQXY1W8WIykQ2VU4E=;
 b=RBd9QuX7/i7pZ+86b14jfF4SGWGJoKpRdu46E8BxIGvSsF4ckHFqMzKzYfAyGtQOzBOHlkJEksPB
   RPkuyMWZTUaDFgiXBc7IOQCaEFgSJmnvhipMIK/Fpmhe0IVAM9lvngTUjiPz4EkTDPOgwQH6ePdA
   am1ElQnl9lbKRjJrg0yA4swZgk14CnJUTL3ajlHYQT6GWOLeSZ35qfk1rK8ItZZ9r+lEEHw/NPoi
   ZVbzFLxvEZEXs/FTqoHHMR4wkTn4ccG2bsXsS1o2zao1XvNXtHAmefR1pQH29GzySm8akbLRxkq1
   33wKK1b0H5PC1Po/jFbyHivPd2vApSDdYMfOEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Dyrof4rhxxz4dTYsosS6+CL1fmPQXY1W8WIykQ2VU4E=;
 b=OyAdMitdE87eh1dDnJcIJFZn/Kpxh3cDYpUIXCL4qJwEh/WgBkPQzodb4wn8QXQodxg6eA9ZbY9T
   szb/hIQhQfYS4Qc21tC7QdoiaLNMcV7vh4cnQ7nXKh4dyqv5en3jnD7GYy0zH1BpTJASDtAaIF+0
   uGwem3iu4WD8KMOPSS0aArZ8ceprrZddhCfCDg7fxdG8ygeF0LFve8cEKB8StZWOwatxOP8+sfKx
   dkR00bA0SmxpuyevA4tNOxSqxsuFeQc6NJncodS0VkDwbbUJfSAJFWROCKUf2ZVR+NXbr5rmUSig
   ZmA+1S+rdidzBxvgK6e/L/JlGI7ggMdJPYo2Pw==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RG4006DCJOHAUB0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 05 Aug 2022 04:12:17 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fasheh-com.20210112.gappssmtp.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc; bh=NxGvtJ09wrlfmeu9E+7irQmCAdfUb+A8PvR2ZNE5SzA=;
 b=d7zAF9f3z4KP0UeFSggOLMCnBn++3GoUprL9maUaGm0kSTRF2u+Wz4oE4W1d4E475e
 A2nEKmHT5y0XmTCAoTQcY84W/5p/y55nFogZZ4LFcaKcOl/GHkaWrRSIm6sQuHZqPB03
 w17Pqr8UAyLrSEZq4NeZZawyDV4fL/l73nN1Yj0feG2l0Gpu4fo5kwHG8eOur+sy3P/V
 vbQOJri81/PUFtelYegsVPxFwr7g/0UE4fBEpcyL8kzLIUecyAtPSL8HSkh0NViPdIsc
 HmMBZRfueK1IM/2x9c+taS3jZrAevp4aITdm+zVy53Fcwz/eqMjWEZGKpjA30woZE+f6 mNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=NxGvtJ09wrlfmeu9E+7irQmCAdfUb+A8PvR2ZNE5SzA=;
 b=YxytmtwmxY8/w41qWuGFwd24mE71314dbbYt3zS3G21oiWsK2XEn3Dz0pXLOqhOvxs
 aJCxFU/0905HoHQsKrUIt/kEy7rBtLD2j44YWUr4QuESNeaQ23Mu6TFO9qusKm28bSwS
 sxvqBd6iMuHHq5HGo+w+PV48rSNj0VDZn5W5IoqmSQyXxY+xEQ5qRVIoUBxCj76NfDNn
 99CYLm8GjPJxZO40bn7rXl3a3zgA2aU1VDbpuqgxUEKMm0FlLSox4ZIZIRYPf/7C2zMx
 1fVp5WhXFChK6L0Iyqi+M1BSX2nVSgqdoBu4pVhwLv7ImADVCaNaQYJc5HQo19eN9tHM fBPQ==
X-Gm-Message-State: ACgBeo1Km/EdLL6/GxU6ZJrSqL9o/qTITSjX8abB5MDMTSFmcWgls9vf
 x9ZveKPW2iX3PX7ca3zMa8vmnW/c5tJTkwNpPaA66Q==
X-Received: by 2002:a05:6638:268a:b0:341:529a:5133 with SMTP id
 o10-20020a056638268a00b00341529a5133mr2141626jat.18.1659672724141; Thu,
 04 Aug 2022 21:12:04 -0700 (PDT)
MIME-version: 1.0
References: <20220730011411.11214-1-heming.zhao@suse.com>
 <20220730011411.11214-4-heming.zhao@suse.com>
 <CAGe7X7kLfsUfb1+yYgD4PffnJYvJVeqrLtub8qC=ujC2gxEzTA@mail.gmail.com>
 <0b33b0c2-71dc-3961-88ee-fb29dedcc7c1@suse.com>
 <CAGe7X7n7J52w3Jn5Sz5=f2AQohLMK5xK2Pjsd9oPAMSn52+SrQ@mail.gmail.com>
In-reply-to:
 <CAGe7X7n7J52w3Jn5Sz5=f2AQohLMK5xK2Pjsd9oPAMSn52+SrQ@mail.gmail.com>
Date: Thu, 4 Aug 2022 21:11:53 -0700
Message-id: <CAGe7X7=F16yaowhTrLgSGcS4gsGUbtjBgEamfur5n1C0hgRA=Q@mail.gmail.com>
To: "heming.zhao@suse.com" <heming.zhao@suse.com>
X-Source-IP: 209.85.166.44
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10429
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 adultscore=0 impostorscore=0 priorityscore=141 bulkscore=0 clxscore=163
 lowpriorityscore=0 mlxscore=0 malwarescore=0 mlxlogscore=995 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208050020
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
 AA6agR7YngoMvPrZTjTLGgCanlq6KI/OxPvOYc4Wakvfy+JlYWJhylOAWKCtR2ZcPFRRrRYXyG6uf8nR5F3V0yQfCD0=
X-ServerName: mail-io1-f44.google.com
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: NWulCDPjuxQVzKxtUKviyInx65pWw6kE
X-Proofpoint-ORIG-GUID: NWulCDPjuxQVzKxtUKviyInx65pWw6kE
Reporting-Meta:
 AAFna5L6ZmK7LTzgjQ5P5v5AoAUSkXFhY+nuyx3NCrAdDxPpK6BKtr//B7iKig+x
 Se3IcFLzmSlv4uhNNeT5Y0gZEk8K7OPDd8Gbosz3Q8xMH7dJonXStjR02yHGKA9V
 0ja+9NES17+sYVZQfYzeDYAQy30HEisL9M1riwWK1fBo9ZuXzStfgdDNrxxnATsS
 Bq68BrudWLOooI7vCutH2zfnhVVyY2mx1JnhvN/5owEwaNYfiMc5y3WS8Rd9JOmH
 KqbboDXDfxgb4NOc3xKCXmVZLYXwlWeBpc9534OjCIjh/x/5neVGBluuapEc5zzZ
 UawQd8mThD+BQ68CF91Jb+ANa6+GxFwxVopUAkqaISp5ESOFoaprk/mMx2WZNLcr
 ryNNsEqvlOSRbQ1hHcSR3sLB6+gqzGMuG1Ihjvc/rRgX5pIS4/ISGk5d03A+RYTG
 hPjC3dANrRvlPdRYOrzc0aDkrPHJqheuz2aYBlUlOPwyRJKRq0uQYBb7l6JmHvYJ
 kkq3qHS+P7CcDfrJyA9E4L++gORSTMiFjtdcrUBpLT4=

On Thu, Aug 4, 2022 at 4:53 PM Mark Fasheh <mark@fasheh.com> wrote:
> 2) Should we allow the user to bypass our cluster checks?
>
> On this question I'm still a 'no'. I simply haven't seen enough
> evidence to warrant such a drastic change in policy. Allowing it via
> mount option too just feels extremely error-prone. I think we need to
> explore alternative avenues to help
> ing the user out here. As you noted in your followup, a single node
> config is entirely possible in pacemaker (I've run that config
> myself). Why not provide an easy way for the user to drop down to that
> sort of a config? I know that's kind
> of pushing responsibility for this to the cluster stack, but that's
> where it belongs in the first place.
>
> Another option might be an 'observer mode' mount, where the node
> participates in the cluster (and the file system locking) but purely
> in a read-only fashion.

Thinking about this some more... The only way that this works without
potential corruptions is if we always write a periodic mmp sequence,
even in clustered mode (which might mean each node writes to its own
sector). That way tunefs can always check the disk for a mounted node,
even without a cluster stack up. If tunefs sees anyone writing
sequences to the disk, it can safely fail the operation. Tunefs also
would have to be writing an mmp sequence once it has determined that
the disk is not mounted. It could also write some flag alongisde the
sequence that says 'tunefs is working on this disk'. If a cluster
mount comes up and sees a live sequence with that flag, it will know
to fail the mount request as the disk is being modified. Local mounts
can also use this to ensure that they are the only mounted node.

As it turns out, we already do pretty much all of the sequence writing
already for the o2cb cluster stack - check out cluseter/heartbeat.c.
If memory serves, tunefs.ocfs2 has code to write to this heartbeat
area as well. For o2cb, we use the disk heartbeat to detect node
liveness, and to kill our local node if we see disk timeouts. For
pcmk, we shouldn't take any of these actions as it is none of our
responsibility. Under pcmk, the heartbeating would be purely for mount
protection checks.

The downside to this is that all nodes would be heartbeating to the
disk on a regular interval, not just one. To be fair, this is exactly
how o2cb works and with the correct timeout choices, we were able to
avoid a measurable performance impact, though in any case this might
have to be a small price the user pays for cluster aware mount
protection.

Let me know what you think.

Thanks,
  --Mark

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
