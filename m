Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9231C413781
	for <ocfs2-devel@lists.linux.dev>; Thu, 10 Sep 2026 08:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027743; cv=none; b=R+loLlrrUEYOihsp5X5leiTQQNeQkt6QSBpoB2cTC1ojjveUX7AfEFxsvDfCRrfJNB7GtIGraaNyMGqFAbeguexv9tmisFbkB+x4P7QF16e2KBAWNonjKkSKoqLEvknOA5HUUi2PBVyC0wYoleSZ4mEUvNuCm8CsB+R9e7mkL8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027743; c=relaxed/simple;
	bh=sZG2eexUBDvxgaq6ysoGTc36spnht+MNulg2i1alcXU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rKkiumgttTPWyluZ24Wz2RbQYWIxym872L1apNugroSr7R2Fa9m1hg6fvEEz1yzV25TFFcgpi3U/jHoUMEEV6VPPVR/47QJf7ZTyV28M3UV1OrMXb0JoYjC+0iql3csXXqyDSFcFjaXMz2qwyFbnogcxBcOWBUl6F+LiyYDso0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pPiRgpa+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CCpANugB; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pPiRgpa+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CCpANugB"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68A5HMoo2974690
	for <ocfs2-devel@lists.linux.dev>; Thu, 10 Sep 2026 08:09:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	P7BTTddhf4N5PrxHybbjlwH7viQ1O+pT1zz2AMFb7tw=; b=pPiRgpa+i0kXlw4m
	fqepclc9pletqlBQvxnlcD3vbXxI7ffdS3JSAZ6LpjwntoyNwWtXmEKxEQjxoxKU
	i20i/xkYq+Qbakow9oTJDl44ledqUtNTXWv5ptACP/Owae0VzEI/2LWcDzrlQ+z8
	Qi2lygGNGUGeHjBcEtx4ceEaPzvtRmWlqiB3fYBhcbirDV2hBWcVjvFdnGlWkFyx
	06jgq3AIN2EOUIvox3B40s0qrSTx5K+RUgg0OmNad4cAqA5D97+upvOD5bxaPJTH
	wftptOlTkGJJIl1i9KCxulqNDdbgsnWcdfzGH3aFk8upu0uiTXqwd0SEFfCw45yA
	fJjunQ==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gkcyg2sfb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <ocfs2-devel@lists.linux.dev>; Thu, 10 Sep 2026 08:09:00 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-934a8cd3a8bso129004885a.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 10 Sep 2026 01:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789027740; x=1789632540; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P7BTTddhf4N5PrxHybbjlwH7viQ1O+pT1zz2AMFb7tw=;
        b=CCpANugB4cS4DymuZn56umpo0FOOHsn+2PKnOFyYeO5fLunhZ+LEYht6tbRgS6ee3h
         W4NLZlQ1jx++OkB77XGVzt8Kl7rMo9zACHj/1gmUCJ20HThKbrHSpGBj5w8eVtea6uEx
         ivKtBBpqpDry+E883N0Fn9gKN15a9SWxCoEt7kgn21oTjISMPjhxVaGRbaMFeTQHHGBK
         S1ZSdCTQ27konyK6CNA4I4jepcqe/SZ2gdOOZb+rveEn1ZLz38zlcxC3HNDru54Vbqrl
         C6QcCI4EVo/N29RSTyAZEH563u0wxHMtASvvu+xx44uQVX3lRmjRbcxIK5DPnrLUsXdf
         0Vog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789027740; x=1789632540;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P7BTTddhf4N5PrxHybbjlwH7viQ1O+pT1zz2AMFb7tw=;
        b=eL4pumU6Ts/K86sx4Nm+SwOeWhvqah3xNmpj5KpczK5Rk4dDZ6EVNNNXbUmgmdczhg
         AGycVLtAPioHtCYShVHMd4gPNQawXlq45JeFYvzIozEkCLs8TZIUHVm54Z+N8cW/q9X1
         qNXDuezymcfGQei/JnjcwjVKVjhUOTPtpHPkECRTnfLFxgKU4lzC3+qVTwWHyXhNtuSd
         mbOE3OMlGe6jaXyloFOc8rmnS2dLYzLdlicveqFrvYpTTnI/RfnhIqOf8+lrn9MgMOox
         YbZlEF3mAqxYwmpD7jISmQ3rdDC/kxStDTJiaD+cRHic7sn5FFpYKiB5wAMBSJNamQcb
         s5Ww==
X-Forwarded-Encrypted: i=1; AKwUvBxcoGgAgLZqCqRbfQqZgqobfOyg9tZUrhBW3eeyHejkUEbt+JzaeBvEoKV+s4TlhOFwJ6vxQJZPAYpq+A==@lists.linux.dev
X-Gm-Message-State: AFuF++m+x+VU1Wg8L04f+7fASG8E/lh6d04cnK5Jqnh81StMzZPfPhPF
	fUBEAdB5GhKO3HcGQ1iOWugtZMvx0BLX5h9ac1y2mAFFbAigNnT3VZ5LCJW7gWGmB8YNq/hsyKC
	yVAtuuxhCSNCWeGVjSe2xMh1Jf/0iY+Rxw7nHFocRTNwHe7XTgIx3KVAl5xGwrfyc0Q==
X-Gm-Gg: AYBFou3kUA3rVgaj6kA3j1ySbaoYOEtor+YQ1a21Ir3VFmZKttYBhATbeF4CgLZ7k6E
	s702E++bIqPXxvm69cQCp7B6C0qvoAGYe1yJtj5DZ31xrNSnjiAfJ08/B8xEczykMdbm7xLQxf3
	+SHDK9m2e7S4QdO2/WSEWTXyJ2cahwC2zJ1xibm38RTULzOcjnb3ftIvHEq1ojzkMLQzg8d7adU
	wf5ABzEGBcdIWaWAL5KS0LjN4V4+5GNuFaYSoVqNAgLw6IOm37xkLILgGX7rtktjXkyXo9BoXCp
	0hEOx5psF3fXZ8vNRAfml8qoQgfmCnim2U4Z1H55lCedO//BIaieIUgumjYBoeq7tT9m0C8l22J
	RnY1GSlWgVXFniwr1WfzRBg==
X-Received: by 2002:a05:620a:4409:b0:939:8bc:8826 with SMTP id af79cd13be357-93991702d25mr3092766885a.2.1789027739712;
        Thu, 10 Sep 2026 01:08:59 -0700 (PDT)
X-Received: by 2002:a05:620a:4409:b0:939:8bc:8826 with SMTP id af79cd13be357-93991702d25mr3092763385a.2.1789027739269;
        Thu, 10 Sep 2026 01:08:59 -0700 (PDT)
Received: from [192.168.202.12] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a993d6611asm1966906a12.25.2026.09.10.01.08.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 01:08:58 -0700 (PDT)
Message-ID: <e77d4410-e7fa-4885-9d9f-6dd09fb7cebb@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 10:08:55 +0200
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] buffer: fix NULL dereference of bh->b_folio in
 __bh_submit()
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
        Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        Srikanth Aithal <Srikanth.Aithal@amd.com>,
        Luca Weiss <luca.weiss@fairphone.com>, Jan Kara <jack@suse.cz>
References: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=bMqDs/+Z c=1 sm=1 tr=0 ts=6aa2659c cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=zd2uoN0lAAAA:8 a=6H0WHjuAAAAA:8 a=SRrdq9N9AAAA:8 a=EUspDBNiAAAA:8
 a=xELAsZIkk1thdxp-Qi8A:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-GUID: 4LW7gxM1OOHgzHweheEREzZbzlxfxgvY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDA4OCBTYWx0ZWRfXwd7C4xyuoNyy
 DBXSD+yoaTuPDDEI6rAVmD8pGA2/gv9J/Yd+Kp67hJdsvKhYuKIQaNC6oYsz0PAiCifaECskgHL
 SDLlp49nYhKex6YXfk78NBkGxYkucsGNSGjMlEwNFwrw19SoVApV8ohN4oSy1hpfkngmb7AIgVw
 SZWfmh6tkNE3u2CLYjqN0Klvl8Vzs7ybAxBfpuaYFN4eh3KEA5OswW3mTLrTlRpdYr+Gp9+Ub1Z
 yktK3u/hqiFag0ZU3ea9iEf7EpDpfaPDLoLUZf77J0UH09GbXe1By6NSld7dt6HS5rsP7WbRHF9
 ScElGKlokc/Qq8QebanXbv2D9MZsGfTJK2HAFzcOMYg2UpfhX1MGTzsROWJ1fDeouBnZwYVerXV
 03MMhTwhKOxpvwnz5PSDVU+IkFt4gweK8kO04gHomIqI2b0feVWlpnDOXY6qpukrAq9H9nEV+f7
 TapSAp+BPvq9Jd4YRgQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDA4OCBTYWx0ZWRfX+ovm7+l9FG7h
 i3o39c0pN1ax1cV5TPpGI5/KYJMua11bVfktCASXjpc4407lpXQ+77LbTsnwdMUqhE1sfvUPedm
 +9dMLTn3WkFDfSIstxgQ2Kz5Pf3sIXc=
X-Proofpoint-ORIG-GUID: 4LW7gxM1OOHgzHweheEREzZbzlxfxgvY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_02,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0
 spamscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100088

On 9/2/26 3:33 AM, Joseph Qi wrote:
> Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
> writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
> __bh_submit().  But jbd2 shadow buffers have a NULL b_folio since commit
> 5febcba29792 ("jbd2: point the shadow buffer at the frozen data
> directly") made them point b_data at the kmalloced frozen data rather
> than a folio.  Submitting such a buffer during journal commit oopses:
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   RIP: 0010:__bh_submit.constprop.0+0x87/0x120
>   Call Trace:
>    jbd2_journal_commit_transaction+0x932/0x1b10
>    kjournald2+0xb2/0x250
> 
> Hit by the ocfs2-testsuite fill_verify_holes test running with
> data=writeback.
> 
> Dropbehind only applies to buffers backed by a folio, so skip the check
> when b_folio is NULL.
> 
> Fixes: 5febcba29792 ("jbd2: point the shadow buffer at the frozen data directly")
> Tested-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
> Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sm7225-fairphone-fp4
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/buffer.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 427d8a817cd5..f46fa6413032 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1106,7 +1106,8 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
>  
>  	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
>  
> -	if (folio_test_dropbehind(bh->b_folio) && op_is_write(opf))
> +	if (bh->b_folio && folio_test_dropbehind(bh->b_folio) &&
> +	    op_is_write(opf))
>  		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);


-next has been broken for a week+ already, please pick this up..

Tested-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com> # multiple QC boards

Konrad
