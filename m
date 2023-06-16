Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F927EB64D9
	for <ocfs2-devel@archiver.kernel.org>; Fri, 16 Jun 2023 03:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oixJ81urPPBhuFY6g4o3M4PQQrDkF7N9CBS0DaPRWAI=;
 b=LoWUjKH2VkMEwo7m73wHyD3jUcbE+j5Y2XEiYSRqiWsYH+WpBs397jKKbY3D1Me+AU0/duRpPKgt
   KhUv92wi9n9pg15mQ9lsLFi1EfVf1hOGj5Oss1+RHfHLM2s06+Cx1OalQpWwVWcIR62UlfY3096h
   jCNwfXgBuxjA241rfk7jvIsVpCyyhRVDqOdG16oDavrytK2OduIical9mlWTyA3Y9Ts+ZnVVevmB
   3P8rBImyEaY/s+OM99leYfuxiF5G1WgvbshAVV7vfqaanofZQONXtqDv5EKryu7azCfW6svwY9ps
   Gk1E+mui1CDcXHh7zTOArvEQs2EsDqDDpHYDZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oixJ81urPPBhuFY6g4o3M4PQQrDkF7N9CBS0DaPRWAI=;
 b=S9pUvkNTTXolNmDcoQleSZm/awnTM136zt6o4IVKWiN+pU6Mv89tF5rqpW4cx7Kdq1Ian6Uk0xLw
   4CIAEZmRLLVZsubFXadw9jaV0m6LE6lzW5FbNLCobut4vop1yQRIJAVq7k5uBULSa7qzMwBFOVVM
   AjxJv3liaYixjGT4rc1v8AjTkn0ZZj9kb04Lr7xRLyuVYcgFtHn9Li9yUXG7j7EKbjoHSI4M0cJn
   hAtXNmZ8MRfcWQnvcFaDhwg4/EMZEX50QmdgFkF+5KPjYZtS5DCGs5qpIjRTOvVQaAWU6xIwfcuR
   9QTFyVQ7ILPMyG1F4LQr78CgXOuhkmP8laqttQ==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWB00O1QTMC8710@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 16 Jun 2023 03:27:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20221208;
 t=1686886053; x=1689478053;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=vfMsbuEQzECMDi/ofmaHnjYk6LhJbPsTFGu9ij0ZnHE=;
 b=TyVd3gw+DTSPKvPWdE87N11lhlyBfgvltmiqvAUIqL4ms9qxsfjJF6OIBbLQd38PwX
 BNup85LLdr+sRzmi2c5pUEaJPvODJiWPgP5d/wVM7T5VW+FCAhoNjkySV3mlUvZJ7WUK
 xI/5r0dnY0/d2zErx2veG/MSIoX1Nw3ossW5eAFSWfJglBsoIS9+UrRtOOHBnMV5iyDK
 Hr+y8YDkFQg5tZ/yuA5fWxu2V7zgh3tfP2TPr14XLGPfECTTYmBYZ4YtJhtU9S9cq2qn
 FcH9S5x6ek/9xCh8iJSj3zCXs22ObdY825fJVAeZk6VHlFsyylau9dQQJiaknjfc4Vd7 8AkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20221208; t=1686886053; x=1689478053;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id :reply-to;
 bh=vfMsbuEQzECMDi/ofmaHnjYk6LhJbPsTFGu9ij0ZnHE=;
 b=WsvOyLQKejFwO6TvJQ7i/TxdMqiaw4yLOmKSH1bxW7CH9KEAj2clxtF0OcBmDDyOIL
 45zw3b8w/5p0t81T2j4FBZIAmqtL5zLoHFd8iVo/c0zyjW8QbfAO2Z77J0yzQc4r91C0
 US0Bgc9ESRJzOCE5uYFfvaPcWiAs9LalYIfQd6DAGJV5TaHX2ZqrVG7NbHov/h1MHSnr
 seeBFFer4K/8wSjrKk02yXl3MGSpCLjH7senwY60psr5ZSPhIqFlDsy2OALE+Ah8qHI9
 Qxgzkyo8E9H/A0P4FoSYj6UjlVJ7I5/OSy6561Bf9FlCU5rKdu7isL8qpKU4AK+b2BAy i80g==
X-Gm-Message-State: AC+VfDzTXoXnqdYWj91Y7hvvEuGEDvK9/lYQfbdNOaFRGB1bFyhvGxYK
 xYXJFwVe5UaQe05oObuKaa150LSDf8qCiamydFE=
X-Received: by 2002:a17:907:6d1b:b0:977:b397:bbfa with SMTP id
 sa27-20020a1709076d1b00b00977b397bbfamr624141ejc.6.1686886053298; Thu,
 15 Jun 2023 20:27:33 -0700 (PDT)
MIME-version: 1.0
References:
 <CADm8TekHVfLHzKBLRfj7TwZiw=eL=VSgPpuhdpx_FSjNUXNtHQ@mail.gmail.com>
 <bb92b1f4-8433-de5c-0ce1-b23e693b8ad5@linux.alibaba.com>
In-reply-to: <bb92b1f4-8433-de5c-0ce1-b23e693b8ad5@linux.alibaba.com>
Date: Fri, 16 Jun 2023 11:27:23 +0800
Message-id: <CADm8TemyTpkOb-FFxWsB=kckBqWrBsDngodb1SfEZFC_vKFYFg@mail.gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
X-Source-IP: 209.85.208.46
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10742
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 mlxlogscore=844 priorityscore=381 clxscore=247
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306160030 domainage_hfrom=10169
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, baijiaju1990@outlook.com,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [BUG] ocfs2/dlm: possible data races in
 dlm_drop_lockres_ref_done() and dlm_get_lock_resource()
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
From: Tuo Li via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Tuo Li <islituo@gmail.com>
Content-type: multipart/mixed; boundary="===============6371235962263784786=="
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 ACHHUZ7VgjizzQyKA8t3kEX6YWq/gmKd2iu1MwSJHGZpAcqOwnXF/xnFiQRgG07tvFxc+uRen7rGGuzPY+BAITQQhD4=
X-ServerName: mail-ed1-f46.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-GUID: Ms9iI4bmD6sAomWu24M12-NkiMQ0mt0k
X-Proofpoint-ORIG-GUID: Ms9iI4bmD6sAomWu24M12-NkiMQ0mt0k
Reporting-Meta:
 AAEuORDanzU8M0MnKohNQdAp8wtQkkfdS6QrWxWa/+5TWV6SaaftbPWrSOtASyV7
 eOk+vFGyNmDGbF80k5OSQmCeLtC7VfF5TwA0AbF/Ps/H5Qc57xjrBv8yLX0g2QvS
 tExq3REFJLTnYAuGkzjb7j+0bFsQKBeHtPqbleRYuUa8BkK9RgVBgq0HgiWWNvMm
 6nKmu2AMQGyXHzqPoiZPLmDN068XCdottWRKwIS2P8LYqjhVHGBInpN8uHKkEDgD
 mVL09OrW4QF0tm8eGy8ApHcqL5dVBslvlFuNj+MRZ2v4rpU13+s0gazV1Nl3mlUI
 m/oeonspN7pmZRSBOvwFgC69wydi18l56qJK4QQ1QDuMtZ1WrL2xYQ5We9FEUPce
 0qH0V6LhqJIDaadx1ohq4bk5AvRXOAIhD7C6Te6APwwEXnEvmMDaZ4yll4m1Vy/z
 XrGgf/Hm4dym5s0x9MBeFBFnTyKyRWWQ2hg99q0ayVcljhN7xYPWFzgArv/mL8n9
 g4tj5mOJvGFSRwFS9Ls1knb5FdK0+CvXr9LZH7PcEZIn

--===============6371235962263784786==
Content-Type: multipart/alternative; boundary="000000000000fbc87605fe36c35e"

--000000000000fbc87605fe36c35e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Thanks for your reply! It is very helpful!

Do you mean in dlm_wait_for_lock_mastery()?
>

Yes, it is dlm_wait_for_lock_mastery(). I am sorry to confuse you.

Even if owner changes suddenly, it will recheck, so I think it is also
> fine.


Does 'recheck' here mean if owner changes, it will go to the label
'recheck' at Line 1011.
If so, when rechecking, the race can occur again at Line 1023. And thus can
cause infinite rechecking in extreme cases.

Thanks,
Tuo Li

On Fri, Jun 16, 2023 at 10:11=E2=80=AFAM Joseph Qi <joseph.qi@linux.alibaba=
.com>
wrote:

> Hi,
>
> On 6/13/23 4:23 PM, Tuo Li wrote:
> > Hello,
> >
> > Our static analysis tool finds some possible data races in the OCFS2 fi=
le
> > system in Linux 6.4.0-rc6.
> >
> > In most calling contexts, the variables  such as res->lockname.name and
> > res->owner are accessed with holding the lock res->spinlock. Here is an
> > example:
> >
> >   lockres_seq_start() --> Line 539 in dlmdebug.c
> >     spin_lock(&res->spinlock); --> Line 574 in dlmdebug.c (Lock
> > res->spinlock)
> >     dump_lockres(res, ...); --> Line 575 in fs/ocfs2/dlm/dlmdebug.c
> >       stringify_lockname(res->lockname.name, ...);  --> Line 493 in
> > dlmdebug.c (Access res->lockname.name)
> >       scnprintf(..., res->owner, ...);  -->Line 498 in dlmdebug.c (Acce=
ss
> > res->owner)
> >
> > However, in the following calling contexts:
> >
> >   dlm_deref_lockres_worker() --> Line 2439 in dlmmaster.c
> >     dlm_drop_lockres_ref_done() --> Line 2459 in dlmmaster.c
> >       lockname =3D res->lockname.name; --> Line 2416 in dlmmaster.c
> (Access
> > res->lockname.name)
>
> lockname won't changed during the lockres lifecycle.
> So this won't cause any real problem since now it holds a reference.
>
> >
> >   dlm_get_lock_resource() --> Line 701 in dlmmaster.c
> >     if (res->owner !=3D dlm->node_num) --> Line 1023 in dlmmaster.c (Ac=
cess
> > res->owner)
>
> Do you mean in dlm_wait_for_lock_mastery()?
> Even if owner changes suddenly, it will recheck, so I think it is also
> fine.
>
> Thanks,
> Joseph
>
> >
> > The variables res->lockname.name and res->owner are accessed
> respectively
> > without holding the lock res->spinlock, and thus data races can occur.
> >
> > I am not quite sure whether these possible data races are real and how =
to
> > fix
> > them if they are real.
> >
> > Any feedback would be appreciated, thanks!
> >
> > Reported-by: BassCheck <bass@buaa.edu.cn> <bass@buaa.edu.cn>
> >
> > Best wishes,
> > Tuo Li
> >
>

--000000000000fbc87605fe36c35e
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">Hello,<div><br></div><div>Thanks for your=
 reply! It is very helpful!</div><div><br></div><blockquote class=3D"gmail_=
quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,=
204);padding-left:1ex">Do you mean in dlm_wait_for_lock_mastery()?<br></blo=
ckquote><div><br></div><div>Yes, it=C2=A0is dlm_wait_for_lock_mastery(). I =
am sorry to confuse you.</div><div><br></div><blockquote class=3D"gmail_quo=
te" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204=
);padding-left:1ex">Even if owner changes suddenly, it will recheck, so I t=
hink it is also fine.=C2=A0=C2=A0</blockquote><div>=C2=A0</div><div>Does &#=
39;recheck&#39; here mean=C2=A0if owner changes, it will go to the label &#=
39;recheck&#39; at Line 1011.</div><div>If so, when rechecking, the race ca=
n occur again at Line 1023. And thus can cause infinite rechecking in=C2=A0=
extreme cases.</div><div><br></div><div>Thanks,</div><div>Tuo Li</div></div=
></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr"=
>On Fri, Jun 16, 2023 at 10:11=E2=80=AFAM Joseph Qi &lt;<a href=3D"mailto:j=
oseph.qi@linux.alibaba.com">joseph.qi@linux.alibaba.com</a>&gt; wrote:<br><=
/div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bo=
rder-left:1px solid rgb(204,204,204);padding-left:1ex">Hi,<br>
<br>
On 6/13/23 4:23 PM, Tuo Li wrote:<br>
&gt; Hello,<br>
&gt; <br>
&gt; Our static analysis tool finds some possible data races in the OCFS2 f=
ile<br>
&gt; system in Linux 6.4.0-rc6.<br>
&gt; <br>
&gt; In most calling contexts, the variables=C2=A0 such as res-&gt;<a href=
=3D"http://lockname.name" rel=3D"noreferrer" target=3D"_blank">lockname.nam=
e</a> and<br>
&gt; res-&gt;owner are accessed with holding the lock res-&gt;spinlock. Her=
e is an<br>
&gt; example:<br>
&gt; <br>
&gt;=C2=A0 =C2=A0lockres_seq_start() --&gt; Line 539 in dlmdebug.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0spin_lock(&amp;res-&gt;spinlock); --&gt; Line 574 i=
n dlmdebug.c (Lock<br>
&gt; res-&gt;spinlock)<br>
&gt;=C2=A0 =C2=A0 =C2=A0dump_lockres(res, ...); --&gt; Line 575 in fs/ocfs2=
/dlm/dlmdebug.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0stringify_lockname(res-&gt;<a href=3D"http:/=
/lockname.name" rel=3D"noreferrer" target=3D"_blank">lockname.name</a>, ...=
);=C2=A0 --&gt; Line 493 in<br>
&gt; dlmdebug.c (Access res-&gt;<a href=3D"http://lockname.name" rel=3D"nor=
eferrer" target=3D"_blank">lockname.name</a>)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0scnprintf(..., res-&gt;owner, ...);=C2=A0 --=
&gt;Line 498 in dlmdebug.c (Access<br>
&gt; res-&gt;owner)<br>
&gt; <br>
&gt; However, in the following calling contexts:<br>
&gt; <br>
&gt;=C2=A0 =C2=A0dlm_deref_lockres_worker() --&gt; Line 2439 in dlmmaster.c=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0dlm_drop_lockres_ref_done() --&gt; Line 2459 in dlm=
master.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0lockname =3D res-&gt;<a href=3D"http://lockn=
ame.name" rel=3D"noreferrer" target=3D"_blank">lockname.name</a>; --&gt; Li=
ne 2416 in dlmmaster.c (Access<br>
&gt; res-&gt;<a href=3D"http://lockname.name" rel=3D"noreferrer" target=3D"=
_blank">lockname.name</a>)<br>
<br>
lockname won&#39;t changed during the lockres lifecycle.<br>
So this won&#39;t cause any real problem since now it holds a reference.<br=
>
<br>
&gt; <br>
&gt;=C2=A0 =C2=A0dlm_get_lock_resource() --&gt; Line 701 in dlmmaster.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0if (res-&gt;owner !=3D dlm-&gt;node_num) --&gt; Lin=
e 1023 in dlmmaster.c (Access<br>
&gt; res-&gt;owner)<br>
<br>
Do you mean in dlm_wait_for_lock_mastery()?<br>
Even if owner changes suddenly, it will recheck, so I think it is also fine=
.<br>
<br>
Thanks,<br>
Joseph<br>
<br>
&gt; <br>
&gt; The variables res-&gt;<a href=3D"http://lockname.name" rel=3D"noreferr=
er" target=3D"_blank">lockname.name</a> and res-&gt;owner are accessed resp=
ectively<br>
&gt; without holding the lock res-&gt;spinlock, and thus data races can occ=
ur.<br>
&gt; <br>
&gt; I am not quite sure whether these possible data races are real and how=
 to<br>
&gt; fix<br>
&gt; them if they are real.<br>
&gt; <br>
&gt; Any feedback would be appreciated, thanks!<br>
&gt; <br>
&gt; Reported-by: BassCheck &lt;<a href=3D"mailto:bass@buaa.edu.cn" target=
=3D"_blank">bass@buaa.edu.cn</a>&gt; &lt;<a href=3D"mailto:bass@buaa.edu.cn=
" target=3D"_blank">bass@buaa.edu.cn</a>&gt;<br>
&gt; <br>
&gt; Best wishes,<br>
&gt; Tuo Li<br>
&gt; <br>
</blockquote></div>

--000000000000fbc87605fe36c35e--


--===============6371235962263784786==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
--===============6371235962263784786==--

