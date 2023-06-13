Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90851C77B7A
	for <ocfs2-devel@archiver.kernel.org>; Tue, 13 Jun 2023 08:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=krO9oNi1jHfdWu27ciHDdoIHzVJqsKWEfLSn0+Lpks4=;
 b=QZ8MCSNTO42RpZ607CqZgNQuiBeN+jATAXgJA5na2n0bt4Olg2eKuer84FhvZYPyE3QvoP3X9XLm
   rGerHzNe2j/bCLk4HcSWsYvFarxemSToWHnkvyKzgjtPFiY8AD7hT/n0Q7f0/ZO2s20uRDpajJ7m
   8uqGWhiLu/lh4kJ2DZRo+4+dPs+QuekLpG7J8/nskMX2OWAeIBs9LHbHaIM0pq/BQik0FF3BNYG7
   pkJ/c1eyXH4VjFDKSnYKxQBC4otEtqJ9jw3VTbzFHvrB9l9Jg7y6FMf1RfFc4Datq+zcLl9hnaH1
   KQH5ONiP241fbaMVDyp5YkGwwvfZIL0wLB9vBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=krO9oNi1jHfdWu27ciHDdoIHzVJqsKWEfLSn0+Lpks4=;
 b=tfQtbMlqd1tMZgaDNHY9pXW6S2neZply/LAhKt7xm+VSlre/O514JZCHH2pVbgl6ZLP5DIq+LIYO
   7KgrFc3Ja0mUXPkCsvcNYQOrQrsa+MatAsEi6plMRA8e46+MweG7m8zXLHbttciF4MPYKSpeWAQl
   FgfdSY09EFG+rUs0ezTWcbP5yu0Jx7EVY/7Pqy6RbYFTOPjbEkGw19Cl/RwQwUnfSjEf1kXew4cf
   wPOnqnJvGcJkeX87M69LxQf4493fGeZNPb2rC6Chz/JqEnqXuecb2IXmTV905rbq4yGLK+6gJi2u
   YlDC2iB57cxapfRdtbORKGR36Aox6E/hcZyfIA==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RW6002QTNBKG1D0@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 13 Jun 2023 08:23:44 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20221208;
 t=1686644611; x=1689236611;
 h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
 :date:message-id:reply-to; bh=p3DLPGE4D9Z8SbZdW/RYHosEZacEekRV7RL8tDDrU+4=;
 b=bD0MaWo67LldtpN9HqiyUibijCW7Db258m2tDs4Y2PGxp8wMswYaZ6RA/F90otOgsG
 0pu5Mz1hhA7oeLmzCLps1OZ8FZcCef92i0m0dSO/3JA60fbrsQdhR9Oh+4hRXlkyaeWe
 rHi1T7x1TmhKTT0oSPNCX+NBjXeHVVK3GHN2SNfJW1vsMO3wqaLVNJR7cqVUnN0v0OnN
 zLNfrzA+NEVnF5Q35cmvbcEY5CfCjoyNAMr8TjiEx3CttClDkikmJqzBKKHYM/B8FMUW
 7TTGmnqN7USVfUqVYH2D7YbLuqN6Uf6U8EBJ1XemcWEISLWXaslHvV0rpHl9BQHs3Adw nzdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20221208; t=1686644611; x=1689236611;
 h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=p3DLPGE4D9Z8SbZdW/RYHosEZacEekRV7RL8tDDrU+4=;
 b=dKS7PR9QfoeJWCjwcZ9ft8WR23X5SGCc2kyd8KUCJ7O/SoVcr3l48ZWtVrE/6Tk+LF
 W02/RR3MjUcI0SMv+bbC0yKrB+75nIaFmc2eJSInsxm1TjAji/p197pdvHO+m78HEIPn
 qBM3q+aEjew0QKLHdgUV18Y0G/nxMYbYE5aCNPBlZUZRfT0/+AMjT78j9Sd1khpLo6YP
 i5PG4YiNKC3V1boKDOWT73V2+OrdfjzXt/gqAuWc28wkljQox04ghhTbZi8G2ALEIGAD
 42NTQlEjee6TkxW/jzCDiro5aiua16Fqff7m4O3ftv/O5Z6r/ESRDZlj9gm3d8Do4O3f 68ug==
X-Gm-Message-State: AC+VfDxobv8ylXPZhSXSGN+1TNI/l+c15nj34P7yqcbjcwoxFVuvwvA3
 xaL1N3fiVJhmyKzBJfcxoUe0YVF5dCkdikhCoDE=
X-Received: by 2002:a17:906:9b8d:b0:974:e755:9fde with SMTP id
 dd13-20020a1709069b8d00b00974e7559fdemr13151247ejc.19.1686644610955; Tue,
 13 Jun 2023 01:23:30 -0700 (PDT)
MIME-version: 1.0
Date: Tue, 13 Jun 2023 16:23:20 +0800
Message-id: <CADm8TekHVfLHzKBLRfj7TwZiw=eL=VSgPpuhdpx_FSjNUXNtHQ@mail.gmail.com>
To: mark@fasheh.com, jlbec@evilplan.org,
 Joseph Qi <joseph.qi@linux.alibaba.com>, akpm@linux-foundation.org
X-Source-IP: 209.85.218.49
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10739
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 spamscore=0 bulkscore=0 priorityscore=445 mlxscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=661 unknownsenderscore=20 clxscore=341
 impostorscore=0 adultscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2305260000 definitions=main-2306130073
 domainage_hfrom=10166
Cc: baijiaju1990@outlook.com, Linux Kernel <linux-kernel@vger.kernel.org>,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [BUG] ocfs2/dlm: possible data races in
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
Content-type: multipart/mixed; boundary="===============7670065922088548937=="
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 ACHHUZ5FGnNA+Vji5+silSiHoWOTM60IoA5gbdKl5H3RD/DDvVuslSFE1JYh9IXYoKHUGxnqA+v7WJ2qfeidsbGTzkY=
X-ServerName: mail-ej1-f49.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 1kBluId4SnrGqILxEGu5SywfUI61TEYi
X-Proofpoint-GUID: 1kBluId4SnrGqILxEGu5SywfUI61TEYi
Reporting-Meta:
 AAExjpX3ILwFfLE2iI5eZNiVefBfo0jcLVH6BC25593kUKd/MHj1bR4tOUKDz1An
 DqpWkDWpfsw384GLiRBhovUbSIKwbvCMFmKDrdHwA/1ei/RcAIbfjnUbCAUWB1ht
 MgBGBjv1BH6wrYurjAkUP8N9SA1LH9kGrtHH0FnUtELlfZp43GpCKiNbIXgMXJPz
 R50+yIezWPMqglJcWyRuBQ1Z0U73CkPA/ULzQbIqx9f3BSM1JOYeVAf3Ak38Bc72
 jrcuk0Sm/Gj0EGZ8l+dkToWvNanwyDtD2vY7NXou1z3NRlL1rFJJOo2nTQ/cZfKP
 DnmdBZ+8Sx8/H969iV9Wa9eHgteJeiiezi+Y8+AzAWIH5AiijznRplGyjRwX756R
 9KAULu/nWLv5Y8f59x5wGpGs8hpb6/pN04p/Iirn9bULJy8qM5SZL+A/LCQFzXZ+
 2c3m8OXkr4MNkJKdb78u9Y+v/ZLXYGG3MxfkwwHsPxwRsXDkzxvLILLJ58SnCUDy
 j2W+CkmitM7/tIBsPMHdj5jH8nKDXJQm40iy5uXePoY=

--===============7670065922088548937==
Content-Type: multipart/alternative; boundary="000000000000e5fe6905fdfe8cac"

--000000000000e5fe6905fdfe8cac
Content-Type: text/plain; charset="UTF-8"

Hello,

Our static analysis tool finds some possible data races in the OCFS2 file
system in Linux 6.4.0-rc6.

In most calling contexts, the variables  such as res->lockname.name and
res->owner are accessed with holding the lock res->spinlock. Here is an
example:

  lockres_seq_start() --> Line 539 in dlmdebug.c
    spin_lock(&res->spinlock); --> Line 574 in dlmdebug.c (Lock
res->spinlock)
    dump_lockres(res, ...); --> Line 575 in fs/ocfs2/dlm/dlmdebug.c
      stringify_lockname(res->lockname.name, ...);  --> Line 493 in
dlmdebug.c (Access res->lockname.name)
      scnprintf(..., res->owner, ...);  -->Line 498 in dlmdebug.c (Access
res->owner)

However, in the following calling contexts:

  dlm_deref_lockres_worker() --> Line 2439 in dlmmaster.c
    dlm_drop_lockres_ref_done() --> Line 2459 in dlmmaster.c
      lockname = res->lockname.name; --> Line 2416 in dlmmaster.c (Access
res->lockname.name)

  dlm_get_lock_resource() --> Line 701 in dlmmaster.c
    if (res->owner != dlm->node_num) --> Line 1023 in dlmmaster.c (Access
res->owner)

The variables res->lockname.name and res->owner are accessed respectively
without holding the lock res->spinlock, and thus data races can occur.

I am not quite sure whether these possible data races are real and how to
fix
them if they are real.

Any feedback would be appreciated, thanks!

Reported-by: BassCheck <bass@buaa.edu.cn> <bass@buaa.edu.cn>

Best wishes,
Tuo Li

--000000000000e5fe6905fdfe8cac
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<br><br>Our static analysis tool finds some possible=
 data races in the OCFS2 file<br>system in Linux 6.4.0-rc6.<br><br>In most =
calling contexts, the variables=C2=A0 such as res-&gt;<a href=3D"http://loc=
kname.name/" target=3D"_blank">lockname.name</a>=C2=A0and<br>res-&gt;owner =
are accessed with holding the lock res-&gt;spinlock. Here is an<br>example:=
<br><br>=C2=A0 lockres_seq_start() --&gt; Line 539 in dlmdebug.c<br>=C2=A0=
=C2=A0=C2=A0 spin_lock(&amp;res-&gt;spinlock); --&gt; Line 574 in dlmdebug.=
c (Lock res-&gt;spinlock)<br>=C2=A0=C2=A0=C2=A0 dump_lockres(res, ...); --&=
gt; Line 575 in fs/ocfs2/dlm/dlmdebug.c<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 s=
tringify_lockname(res-&gt;<a href=3D"http://lockname.name/" target=3D"_blan=
k">lockname.name</a>, ...);=C2=A0 --&gt; Line 493 in dlmdebug.c (Access res=
-&gt;<a href=3D"http://lockname.name/" target=3D"_blank">lockname.name</a>)=
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 scnprintf(..., res-&gt;owner, ...);=C2=
=A0 --&gt;Line 498 in dlmdebug.c (Access res-&gt;owner)<br><br>However, in =
the following calling contexts:<br><br>=C2=A0 dlm_deref_lockres_worker() --=
&gt; Line 2439 in dlmmaster.c<br>=C2=A0=C2=A0=C2=A0 dlm_drop_lockres_ref_do=
ne() --&gt; Line 2459 in dlmmaster.c<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lock=
name =3D res-&gt;<a href=3D"http://lockname.name/" target=3D"_blank">lockna=
me.name</a>; --&gt; Line 2416 in dlmmaster.c (Access res-&gt;<a href=3D"htt=
p://lockname.name/" target=3D"_blank">lockname.name</a>)<br><br>=C2=A0 dlm_=
get_lock_resource() --&gt; Line 701 in dlmmaster.c<br>=C2=A0=C2=A0=C2=A0 if=
 (res-&gt;owner !=3D dlm-&gt;node_num) --&gt; Line 1023 in dlmmaster.c (Acc=
ess res-&gt;owner)<br><br>The variables res-&gt;<a href=3D"http://lockname.=
name/" target=3D"_blank">lockname.name</a>=C2=A0and res-&gt;owner are acces=
sed respectively<br>without holding the lock res-&gt;spinlock, and thus dat=
a races can occur.<br><br>I am not quite sure whether these possible data r=
aces are real and how to fix<br>them if they are real.<br><br>Any feedback =
would be appreciated, thanks!<br><br>Reported-by: BassCheck=C2=A0<a href=3D=
"mailto:bass@buaa.edu.cn" target=3D"_blank">&lt;bass@buaa.edu.cn&gt;</a><br=
><br>Best wishes,<br>Tuo Li<br></div>

--000000000000e5fe6905fdfe8cac--


--===============7670065922088548937==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
--===============7670065922088548937==--

