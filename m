Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E483587DE
	for <ocfs2-devel@lists.linux.dev>; Sat, 31 Jan 2026 14:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769871510; cv=pass; b=hsN6u8GlNr9uBeuO8UPb101TG+NYUm5lw/30ns4kl16MciLlX9RQvhoXWZDGFTssrn4C/3DQhXbPHpzeAEpjuSTIeYTZbpPd/96XBqB4xb5KUF9rrWzlHeDlGRQ2epA9+f2jBYf0Fga3O6FujQguxe36jxp4AkLCwBfy1aiIBYc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769871510; c=relaxed/simple;
	bh=XoPjc3FsSnhAH36Ksfm3BAJI9jxzPUWZyt5vdnTXd18=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uDEkN+2B6dzG9U3LMQL5eFqzgoaak6JMlG5SX4jzCMjX5AU6cYBY3vRW6+2btWeLQE9Zu7ypZKwBLn2s2qhz0JRH3sBlhyY4OLV8cSfDoE9R1G+cnpx8/XD1V897OhNPosM5S+l67IQBwH4lB+5vq4p4ZxGbnVnDloQSWRlqP2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OvHzB4qP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=C6h48IQX; arc=pass smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OvHzB4qP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="C6h48IQX"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60V4Ssmn3956267
	for <ocfs2-devel@lists.linux.dev>; Sat, 31 Jan 2026 14:58:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UjEvOy2WGDJOvuBTZY4HtZUR5P6Q5ANbgXFoz/CfBwA=; b=OvHzB4qP/0jw0pjw
	qHWpKU9MTVgAy76IZFOwvomNtT5ojMnLFjv9vAMABxUYDDdhCdM/mdh/1U5ckbR1
	OHXys8Fv+a3PchmsefgHP4EyfqjCbDSoUrH0Z9vDG2TJsjY7dmvbMOIBYgB07cQC
	ID8YMzju3Vh/8MpgAyNwHRivnN+v5eYDr5CIhLCfTj2mGS4XRYyxzAUFh9cINBG3
	4lbqX8kwiPdpC2X1VC+X57Yc4hGnLxfwp4WoeziP1V7KW8OWpTYzBS2/84Kelkij
	c7Hl5zdRcBv8uYhTITx455LsNqpLBdwF+tnJlsXg2fGzqhfqDBQ8OAyarNxVhK3m
	+a43bA==
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com [74.125.224.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c1are8xsu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <ocfs2-devel@lists.linux.dev>; Sat, 31 Jan 2026 14:58:27 +0000 (GMT)
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-64956cfd789so3847654d50.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 31 Jan 2026 06:58:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769871507; cv=none;
        d=google.com; s=arc-20240605;
        b=caB+Fm+LJDV9RY/ES+ZVlyjaX9XQZJBLPchYmIMlRcQcQijInVbY4iocGmoboTyba2
         HUMJ4+2zrIVQ8sk0QmCG4cMOwdjneBNDh/KQYsAgKBW77DhyTSK/AJPqeM3JZL8LvIIF
         B35kqRMBIR6ZvnocXc2aaR+wpoFfS3oQcky6gennDQtWE9q14qvRFCQaCKKwSC5ObgHT
         vPwJW2xIyg4q0PkBpoxEfHQVzjtf691xYEcD1IO4jE0OWvWZ38h7bzQaqbYKu26M4j0L
         iTvLmbzq5oFnLOmeAYvLnpvgnY4Y/BSvtqGLlJePOgcc6HofdLBd0TjYBvfAynQBt9iC
         NagA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UjEvOy2WGDJOvuBTZY4HtZUR5P6Q5ANbgXFoz/CfBwA=;
        fh=ADmoiPSSCr6/vLqit0RC6A67BTpE0EP/hQB3GXEehK8=;
        b=Obn+tNj80W4vSAuqPU//MTQsQ2pRr/Sw7TIUfwWB+Yu5yBfwH+HvrNYKdaDi1SWws7
         7N+VKa/8AVUAsMY6Rg0YUyYQsCtOkl9vMjyK20zptvlgtlOfynzfZv9OOe3KaFdqe2z+
         Ywt+r0BTNQxpCUfAn/1y8RWjrIl4Uhh+gU8h0Ks7J9h78wKgtb9QuvqkZSejgvQR0t9f
         jeUfEbBZAj0rusI2rRTxcYa8NbOW6X1AEx/9qhNeZZuI1kUdAghk5lF2RlWO3a5ZaCoP
         A22RtajuebQSwhRC0anTFmtgPCPORpcZo5RpWXqVuDP/W896xNL8eroMZ8pzstuRB1gY
         ay1w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769871507; x=1770476307; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UjEvOy2WGDJOvuBTZY4HtZUR5P6Q5ANbgXFoz/CfBwA=;
        b=C6h48IQXVBaQnPCvqR4Lh6w8121KHMdvlFyMalFL//X0Mck4oUCUf86SiuN4VGw6zl
         zis0HWVen6coBHjjlq+Is+OeRjlkx+UryUH+B7FPmYi8TMx9rPgK3ENxluwVQTHUAEmR
         hFDBZItygh1cBDWnfnmbP701WjQ5IaNG7R3DR3+PdRU5xPB3SGP9ajzAaW+6UBbNh5Ov
         l0mcy9gxv53Q1/vBoNa41+ocMtPJ6v25EQJFGdcBleJZAB1LN8xFIIoR2j1IIgm9b5r5
         WLf3iVAUNJAiJscqiI2jpu2uYjCHQ7Kb9ftUW03wmqfwy79F/jmg/9o8l+9ywflJxUgc
         HfnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769871507; x=1770476307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UjEvOy2WGDJOvuBTZY4HtZUR5P6Q5ANbgXFoz/CfBwA=;
        b=L/fgwqu/bEWrsmg1/zReqeHUb7i6Fg2XIdl5DABTyelxILsgpzfH3DBk2JKKt4LE0S
         Od3k9dP1skvgr/WF2BSLJJQP0B3moLtXypSP7TsLQJd+8Cfs5/X/bmvQ5gRURVVFQHO+
         F5xG5eZrxg+DkWEvlBRNn+SRWKs/hf5HGwi7+2w1+ZZFB272ImCGfCl988WOEhnHnW2l
         gWvvbt2oXe3uhXFUhrm2sBaEP5OxpMhWgx245dOY4ffUFOE1xox/qwcahHyB2B/mbzPq
         zFbt6/YgxmsJvEfm3qgTctNYqF92L+/ElhQgGS0gso0NmXngtFb3oxdCRZmvh2ye2Taf
         U0zQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmqNkZFQ19Lc5Cq3ywyFkTJ6++/SWbgUbCqVXs+b9/Xv+6/vToMPLHQCvQ3WQeP6POJtdHzPRSWF6zGA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwtbhZv6wXOWC9C9u0WsQFGkqIOWq0VXcYRwLryksfsdvPHRcvH
	dg690BQjcfJWSCvQytmJHvyqa3EK1gOs9GrNovNKqK+Dqr1KogZgae7j6Gf06JN1XTD1RHGWiAx
	cJcR5W5kTgcgA/AKXGzHhHpjamMi44mPMCRF3fVDDRSwlvS6wsuHdQPEpHKdPz5zqq+cuXXSrJq
	BFsmaCWPaljOAx6UosB/AOCqdHRmgEI5lASg4vHOnI
X-Gm-Gg: AZuq6aLhgpjQvB9OjKSj5g9VqLxBseUQC5VLnKxA1mW0kc7fwI8TUVRzwo9qmKvbpJF
	bS46Ow3tHd9KO/jQ6GQptbvxQ/dpffqv9CO2oxToVxbDKAFLGhHQDAfMfaQBRR20gtVYJTwLldX
	rMbC7cp6ZUhPxLszm+W43goVmc9TVRldYXS/6mur0rEWlM9D7QJKk7/omZOUWgCugmr+w=
X-Received: by 2002:a05:690e:4107:b0:649:7c5c:88e3 with SMTP id 956f58d0204a3-649a8547db8mr4403457d50.95.1769871506939;
        Sat, 31 Jan 2026 06:58:26 -0800 (PST)
X-Received: by 2002:a05:690e:4107:b0:649:7c5c:88e3 with SMTP id
 956f58d0204a3-649a8547db8mr4403441d50.95.1769871506570; Sat, 31 Jan 2026
 06:58:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
 <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh> <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV> <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV> <20260129225433.GU3183987@ZenIV> <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
In-Reply-To: <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
From: Krishna Kurapati PSSNV <krishna.kurapati@oss.qualcomm.com>
Date: Sat, 31 Jan 2026 20:28:15 +0530
X-Gm-Features: AZwV_Qjt6-X-XbfNyo2_bleHjewtRG1qoA5gEXW9Hu9LjqRyKmxz-97xcVzcIio
Message-ID: <CAEiyvppoiL2EiSmVvNV3DEkr7wwyC1Fbwhm14h7Rfus4Z8uP7g@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Samuel Wu <wusamuel@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Greg KH <gregkh@linuxfoundation.org>,
        linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
        brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu,
        neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org,
        linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
        kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org,
        paul@paul-moore.com, casey@schaufler-ca.com,
        linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
        selinux@vger.kernel.org, borntraeger@linux.ibm.com,
        bpf@vger.kernel.org, clm@meta.com,
        android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=NNfYOk6g c=1 sm=1 tr=0 ts=697e1893 cx=c_pps
 a=VEzVgl358Dq0xwHDEbsOzA==:117 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=1XWaLZrsAAAA:8 a=drOt6m5kAAAA:8 a=wEBb_YokH4NsbSDSc3AA:9 a=QEXdDO2ut3YA:10
 a=uujmmnXaIg8lM0-o0HFK:22 a=RMMjzBEyIzXRtoq5n5K6:22
X-Proofpoint-GUID: B83gEWvzlo4SvVnFoVOqEZije6wZN-IE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMxMDEyNSBTYWx0ZWRfX3tiYy1hda2di
 x/1k2W1cSj0uaAmZKLD/CJ9kRS7k9MX31su0Ss9JVBkxwvOF71eYy+yknKEW3Pywso7Pn0JmWjD
 mMTEX/mTQyPN/Sc11dVL3v1kX2+zpIHDGnCMkcrtc6m3Ensp6/cXeP6oDuuQ0q7yBxkRFgz1Hwd
 RdeJSXOG8ravJj1vYontASu5eOh69JRZS6k/8mZRdJZkJt7QeorKDJofalHbTLi0rDblk/QB3yq
 b4KW/r7RyvumlTAoMTpTHmQRUSuRl5qkFZLIhZlZRON2hFzOT9BDe3t1015WjibH8CnZ9IfDyIm
 M4nkKCl3zOAFDfygTZUsH3H/roe1ToR8ib/nFD8xyGOepYhb+vFwtKtc7Cy1e75AGWlryvn+De9
 29kV6ZEns3lCcAKEWBa4J+EwK81zsw//MVOlM0IweCOGYftxmwC5XGf3p0lLji07VBerj0kxJ4i
 VX6Ao1+8bPi2vUYu7ZQ==
X-Proofpoint-ORIG-GUID: B83gEWvzlo4SvVnFoVOqEZije6wZN-IE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-31_02,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 clxscore=1011 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601310125

On Fri, Jan 30, 2026 at 6:46=E2=80=AFAM Samuel Wu <wusamuel@google.com> wro=
te:
>
> On Thu, Jan 29, 2026 at 2:52=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk>=
 wrote:
>

[...]

> I'm exploring a few other paths, but not having USB access makes
> traditional tools a bit difficult. One thing I'm rechecking and is
> worth mentioning is the lockdep below: it's been present for quite
> some time now, but I'm not sure if it would have some undesired
> interaction with your patch.
>
> [ BUG: Invalid wait context ]
> 6.18.0-rc5-mainline-maybe-dirty-4k
> -----------------------------
> irq/360-dwc3/352 is trying to lock:
> ffffff800792deb8 (&psy->extensions_sem){.+.+}-{3:3}, at:
> __power_supply_set_property+0x40/0x180
> other info that might help us debug this:
> context-{4:4}
> 1 lock held by irq/360-dwc3/352:
>  #0: ffffff8017bb98f0 (&gi->spinlock){....}-{2:2}, at:
> configfs_composite_suspend+0x28/0x68
> Call trace:
>  show_stack+0x18/0x28 (C)
>  __dump_stack+0x28/0x3c
>  dump_stack_lvl+0xac/0xf0
>  dump_stack+0x18/0x3c
>  __lock_acquire+0x794/0x2bec
>  lock_acquire+0x148/0x2cc
>  down_read+0x3c/0x194
>  __power_supply_set_property+0x40/0x180
>  power_supply_set_property+0x14/0x20
>  dwc3_gadget_vbus_draw+0x8c/0xcc
>  usb_gadget_vbus_draw+0x48/0x130
>  composite_suspend+0xcc/0xe4
>  configfs_composite_suspend+0x44/0x68
>  dwc3_thread_interrupt+0x8f8/0xc88
>  irq_thread_fn+0x48/0xa8
>  irq_thread+0x150/0x31c
>  kthread+0x150/0x280
>  ret_from_fork+0x10/0x20
>

Hi Samuel,

 Not sure if it helps, but Prashanth recently pushed a patch to
address this vbus_draw kernel panic:
 https://lore.kernel.org/all/20260129111403.3081730-1-prashanth.k@oss.qualc=
omm.com/

 Can you check if it fixes the above crash in vbus_draw.

Regards,
Krishna,
