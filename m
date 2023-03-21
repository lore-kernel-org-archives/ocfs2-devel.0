Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2545CC6FD1C
	for <ocfs2-devel@archiver.kernel.org>; Tue, 21 Mar 2023 02:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rT+VZ0siuWq5TR1Uoyp7ka1FRj9tVSoeRZj9oQ5GcZw=;
 b=VpMJ+o9U0Qoco7NNXfxHqvJXHfu79w6HkmJg2A82OPsOoIY3SHmjsUXQgBlAEkqzZhvL+zREwodl
   M1ZXrkuWsc56inFtWdUUCyGt78aDziLbFVZ+owLZ4mhAJvMIlWvJFETtWDXAUMmufkTQSUA4d76L
   l4F87jY5mBFB+5nWpb4a4SouLMcAkykfQV7I7Q+u4i+zNe4rHAmH/2PT02XHGf2fpxPO37sSkdmi
   dybyTRYiqPy/l42FGIkxR+MOywfl6YiIhFvSERpd+ag7TmAIGVN0M6ILltqsHXxdUkLyGH/PeorC
   Gnh2MS83dtn89PSKMda3U9Xnyo44hWTyrfospw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rT+VZ0siuWq5TR1Uoyp7ka1FRj9tVSoeRZj9oQ5GcZw=;
 b=d7wtqR4vprzDH8eLn+pOi5PlR0hrPP0D7TUd3HSXrujzXmKAi4A5DGw1GTcsrYHYq3RaHhWOMVXE
   E7kXy3vOPqRRap2ppS2dtyG1MGdlJO7wEjDenxFQg7VF0WpKJAiUOVyOOAkxkgOjeA/jl9khgsNB
   UdCdelL7cwCIuGdfHFW5yLaOtTfelRmM6Q5YtLZb0B6IKuAjQT7XiGAznCA1/aOxLSMU44k++68e
   PcVMYPBhRy8jU1KN1dat/pjDV45PReAF2eUfa4kWJDSMY9hvnYR3D4AWQu2Exvl6I07zmgIbCNxq
   3Tj77Tdw8RimP+AJJ0HoqtH53Z3Y5Zsij0bKaQ==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRU00N2QML2WWA0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 21 Mar 2023 02:22:14 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 t=1679365322; h=content-transfer-encoding:in-reply-to:from:references:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=dKDJd+thGVBC1IVFKDXx0SWcwEiYHVdjzeJ2ZoR4z4A=;
 b=nRn2squL6ViLinzwRfbfEtcIacO/x0AWTKI6L35LkLjd6cc36VvHe4HeeHor8bcd/5
 Ch2QCNYI+U9amPD7EHFwEYSxn1yA1eXiexVvO994Dmrc6czyl5pcSQb5ZRCjU5UOr84q
 g4yAhTG1gRNL3EW88wpUY99j6Tz4sGteV1bCA+Cm8ZgknDKcV1tAtnScXxAiUaBE+dp3
 TEOPg/aQilYZSDX7ndrhMQObcc5LvJcTeGk94w22q2aGgPFvWY0IZw3kB07KJoL+mptg
 4R3UE2o8ZVhmT8ODrew+7f1Iclijmfy9X82020mNAxQ2Fbh/TFHM21FTDIoi1iURaoLT lKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; t=1679365322;
 h=content-transfer-encoding:in-reply-to:from:references:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=dKDJd+thGVBC1IVFKDXx0SWcwEiYHVdjzeJ2ZoR4z4A=;
 b=okX6YfM8X2Fyr8iU0vaqCbVMpTGLgjpHirWrQQ4oiYKFtpIc+XZ0DS8FMoeDpcXij8
 Jg22isFH00qc3fFYVAjBKsU0ESGPN9+CRmAKkO9kqrlAm0DqBDaFqpS2hAvOYbvlNP3r
 h1EoQXgQWintlahBvSrT3Cw0vcOlvAU2UbXtG5JuB9vHGTUk5HPgQ45niCjBnIsxjJOL
 CU4vwGVUf8UWdIAIcWZhx7sSe5N/0A+r5M7RwsQjPM20gNjPWJdDk4iTwqOfatOLUuDl
 k8a00Uh8raYqOvTNr5JETNM2qYheSH/WwGoa8WsurONKNMlcyugPJhAnwYXXEY0l0NAg HYRQ==
X-Gm-Message-State: AO0yUKVBL36uPy1OLnEidH3yvF0w97aMrgo2qA6hwvskvGA+5/HZrjF4
 6u5tCSV5w+Q6bL/axN1MbJg=
X-Received: by 2002:a17:90b:1644:b0:23e:feef:38ef with SMTP id
 il4-20020a17090b164400b0023efeef38efmr830586pjb.41.1679365321863; Mon,
 20 Mar 2023 19:22:01 -0700 (PDT)
Message-id: <bba399a1-8950-6a74-da22-4d98fab506e7@gmail.com>
Date: Tue, 21 Mar 2023 10:21:53 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Content-language: en-US
To: Bagas Sanjaya <bagasdotme@gmail.com>, gregkh@linuxfoundation.org,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org, gechangwei@live.cn,
 ghe@suse.com, jack@suse.cz, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 junxiao.bi@oracle.com, mark@fasheh.com, piaojun@huawei.com,
 stable@vger.kernel.org
References: <1679313445246112@kroah.com>
 <63069869-30cf-c45f-3b05-b0b9b46bc36a@gmail.com> <ZBkSwL37/9DpfnvP@debian.me>
In-reply-to: <ZBkSwL37/9DpfnvP@debian.me>
X-Source-IP: 209.85.216.51
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10655
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 bulkscore=0 mlxlogscore=826 priorityscore=360 malwarescore=0 adultscore=0
 unknownsenderscore=20 mlxscore=0 clxscore=34 phishscore=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303210018 domainage_hfrom=10082
Subject: Re: [Ocfs2-devel] FAILED: patch
 "[PATCH] ocfs2: fix data corruption after failed write" failed to apply to
 5.10-stable tree
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
 AK7set965EFtPzTxbfl3UQOO5Iu+ijvBM6v4OzQ+NsX/kbIHi5eZb8oR0u4cxgGMLMwBRZQ1ZSrGvg==
X-ServerName: mail-pj1-f51.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-ORIG-GUID: HpB0LJvnNdgoCcxHEVrjITPZT6tEgpd_
X-Proofpoint-GUID: HpB0LJvnNdgoCcxHEVrjITPZT6tEgpd_
Reporting-Meta:
 AAG4Ih0A1wIEqRk4818F8j3CRYkIMmLd07Fi/9PvCI9iQN9JNuYFEm1J3ZXcOkM6
 WIVzNJBOd9PgmPGJHdf3qUwFriyS0jFdHQfYKFIkEe9RH9AnSeQGT1BGegVAWjm3
 nXddzv2YSidX0fKqTDVQ1tR/6UpUKukFTusFAsYe4/EPAgFx7edTD6Uh/WJ4MzL5
 mj6uqQybFC3rl+4qknxJ9t7SD0qVsa9WNktfIDib6OcY2ZkfkxTIPOcfnNiQnMYK
 EIzfjzKGRt+en7Ozh6JpLNlWNZypRe+K7kAgpM96Ldi1YIEuU5rxw+8g5O3ajJQl
 A4b1XGNp1GmCKu9mTVPY376pywF3osXTsVVBRfxjSaoFhivXAM6UT2k/155oAWAB
 0rc0AxbYUXA5xxxyPRgUC8uZ9Dd1pz3YYHughslxA39WcOTjcnUDESVSZE9kCYW7
 0qR9aPNpVeWKNoCpCU4/zElI8yD2EbxG+RqxVUMksGG08hUxNiqL5ruNiGqmPVdw
 H0z/JuSHGQq4bCtlysu8ZVZeyYtG2qpRXNPpgmsAcCs=



On 3/21/23 10:13 AM, Bagas Sanjaya wrote:
> On Tue, Mar 21, 2023 at 10:06:30AM +0800, Joseph Qi wrote:
>> Hi Greg,
>> It can be cleanly applied for linux-5.10.y and linux-4.19.y in my desktop.
>> I'm not sure how it happens.
>>
> 
> If you can apply the backport, why don't you post it here?
> 
My mistake, it requires feature folio.
Will adapt and post it later.

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
