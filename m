Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFF97C6370C
	for <ocfs2-devel@archiver.kernel.org>; Sat, 26 Nov 2022 18:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=tqSgn47QVyoEiqXVX3GJCqRP9LzzTrKAQZTjBY+Q8sE=;
 b=Fu05/a1X9Rf3UK/eSUaaHyb0pfeITRROA7X/fwpqv6cfht58+aKXiKt4CAIkU8FO5pxCynPclO7h
   MqcvWz7+Q8ICoOkOa6ypEp5Dw3jk3r2lWTUkwH7llP8hLQpEuKb0DDMi5ubOZYcvvvXbKYJJbTxY
   wcmWjlL9H/SragZ7AvBsCtsnuIb+07qq54xRs3m+g7XrDziynh4qCQ1gz+65JXzXHLrjSV6ndM2O
   Oh4NDKP85P/p2uZeYbN2cErL7vsq1vhNgNJx99t74Pe70jv4zxIr4tcamnOGU5kPQjopMgyYQsdJ
   p2U3tH/0bkk6wSK7eiFbD6tzr/83Hap10v7rng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=tqSgn47QVyoEiqXVX3GJCqRP9LzzTrKAQZTjBY+Q8sE=;
 b=Yp4VOd9fhgnACWkBK640auEezIWwcs5x1vPiRgLbC7o+lkSM6aOhkGljiKZpJ9z12BdGqElx9sYI
   PTW6OYjtlqjS/spo9epvAh4dgfN4rNRhgbvaFaMMGsJeTZNzS7CTejxJwq2rvrREExBVLl4qktQ5
   X8OrfYtfchLMzPmI1tH2+NPho6iDLrhabzPS+YpY/+Vfam+UvVtxaTNKUrano+FFYd2cysUdpnpW
   WYFqPYiBRcHeQ1ijtuR9F/RGY+w0jorcl9FUFzXZ2k3wdq3NjkX0qRaYwKZjpovH+6ybJ4//AhuV
   5Tc3JkTedsAiLeHJqWGdZgo1mZA+andJuDVWCA==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLY00ANYVZ0EY00@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 26 Nov 2022 18:13:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
 s=google; h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=0+xfYS/683CuEX8Moz7DN5D+iq5a+HRddPc04OAxt08=;
 b=Tmrax2HtLx9acijQh4ktOiCFNspYBm9czQO9vC+hgh16yhXiq5RyvSKc/8X48Yn6bo
 htTajxPPiW0Lsmr5jl6ZJh1+6V/m5ChitgOSpS6KBQ7ll5X5P1skZcbsej2h/DApNnIq
 u0xC1JtTdPPMF5q+wPkS1LuhqaXUemqkmRceA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=0+xfYS/683CuEX8Moz7DN5D+iq5a+HRddPc04OAxt08=;
 b=62huhLSozN70Z8Ty2K2C8t4PXEQE9RpQcHmdbm3H/1KLvsfqebWNiKAKm0Rseseiv6
 D9c9iNCuyhvNAPbEUqCuVpuRwxAxSsvHVqHTvYx5PIjLWLPDra6tSn0lMJNn0MgqFmpv
 GMMnwb9kvFAxi7bEEidifz0y4bUfkkhbQYuSPXUgz+yyJlR9lVydgXV6YqCdR5LNuRrU
 qeaAJafGRnAbRxTfX7MOV4TlPINJYEvxdaX/Ywn8/cjG86LkCKcSFYtVX2UBew51h6j0
 LSYe0jmfkIc/wPWKRBUeKHRM1nUzP25YEedoV3s+ohJkZX4n93jw1okxdPDuFmLOJ3yB 6pYQ==
X-Gm-Message-State: ANoB5pkqw3DjWLsZa3yltxMTqVS0/DXs0breFlIdeHqKPc2wpB1a/7d6
 i6/H0+QWXhmB1W9hPRStMplKXg==
X-Received: by 2002:a05:6638:3786:b0:363:b82d:d510 with SMTP id
 w6-20020a056638378600b00363b82dd510mr9070708jal.112.1669066860689; Mon,
 21 Nov 2022 13:41:00 -0800 (PST)
Message-id: <4585e331-03ad-959f-e715-29af15f63712@linuxfoundation.org>
Date: Mon, 21 Nov 2022 14:40:56 -0700
MIME-version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-language: en-US
To: Benjamin Coddington <bcodding@redhat.com>,
 David Howells <dhowells@redhat.com>
References:
 <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
 <cover.1669036433.git.bcodding@redhat.com>
 <382872.1669039019@warthog.procyon.org.uk>
 <51B5418D-34FB-4E87-B87A-6C3FCDF8B21C@redhat.com>
In-reply-to: <51B5418D-34FB-4E87-B87A-6C3FCDF8B21C@redhat.com>
X-Source-IP: 209.85.166.43
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10538
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 mlxlogscore=645 lowpriorityscore=0 clxscore=96 mlxscore=0 impostorscore=0
 spamscore=0 phishscore=0 malwarescore=0 priorityscore=130 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210162
Cc: Latchesar Ionkov <lucho@ionkov.net>, samba-technical@lists.samba.org,
 Dominique Martinet <asmadeus@codewreck.org>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Valentina Manea <valentina.manea.m@gmail.com>, linux-nvme@lists.infradead.org,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Eric Dumazet <edumazet@google.com>, linux-nfs@vger.kernel.org,
 Marc Dionne <marc.dionne@auristor.com>, Shuah Khan <shuah@kernel.org>,
 Mike Christie <michael.christie@oracle.com>, drbd-dev@lists.linbit.com,
 linux-cifs@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
 linux-scsi@vger.kernel.org, linux-afs@lists.infradead.org,
 cluster-devel@redhat.com, Christine Caulfield <ccaulfie@redhat.com>,
 Jakub Kicinski <kuba@kernel.org>, Ilya Dryomov <idryomov@gmail.com>,
 Paolo Abeni <pabeni@redhat.com>, Anna Schumaker <anna@kernel.org>,
 Eric Van Hensbergen <ericvh@gmail.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
 linux-block@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
 Keith Busch <kbusch@kernel.org>, ceph-devel@vger.kernel.org,
 Xiubo Li <xiubli@redhat.com>,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 Jens Axboe <axboe@kernel.dk>, Chris Leech <cleech@redhat.com>,
 open-iscsi@googlegroups.com, netdev@vger.kernel.org,
 linux-usb@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
 linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
 =?UTF-8?Q?Christoph_B=c3=b6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Chuck Lever <chuck.lever@oracle.com>, Lee Duncan <lduncan@suse.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Lars Ellenberg <lars.ellenberg@linbit.com>,
 "David S. Miller" <davem@davemloft.net>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v1 2/3] Treewide: Stop corrupting socket's
	task_frag
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
From: Shuah Khan via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Shuah Khan <skhan@linuxfoundation.org>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AA0mqf4lOq6werVuvT/Ru0/037+ZZBKwQ9dV2Uvyt9oiXBE03aeSGMACS9M8fMwvTL7wgcvnDkeJPA==
X-ServerName: mail-io1-f43.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: db2kbi7QaYnUNjBQN436QY99ZQXTZkiR
X-Proofpoint-ORIG-GUID: db2kbi7QaYnUNjBQN436QY99ZQXTZkiR
X-Mailman-Approved-At: Sat, 26 Nov 2022 18:13:43 +0000
Reporting-Meta:
 AAFFJfnDvr9Q6j7LSKqERnFH0DJjX+XYutkd9oNwcBkH8X+lOD+3JM6lz3xf9iap
 WjX4dIbDSv97o5b+jZAV5Et8dFdey+EHMPBF4lD5eN7TjiW5KBIZahZtXeU+Pat1
 +9DpZleZrAtsLRjRnBN+eLh2L6gwbEnX78C42wXAu/vL2GCtwqjKb587DtR3WIN0
 k2JSd2XE2cMPF8DhEo1I1kyO7CzaGCoQSEUHdqDqN4+xJR2AxU6gpKgDj2kT7bGA
 QGrU0oXyyRliJ83J/oQJ3AfWza+spZv0akpzJA8KfmD7yjWo4DiscZlP1fKPj3iN
 yJhYPrxWvn+zjLVQoY7j7fCr+fxj/6N3Q6UuTeOTbVDOzE0A5Ic+IMC+N9a/JAGV
 HNPy6W3mk6zxQLUR4Fd1j2sDp7WAcSb9MjOk9msOqaJUkVMvKc0EqitpNBx07YYA
 DDHocEvnnxXseGNeLEf3G5aPQ9iTNfcwZ7EnyzIpBU1XLMqib4G9y2si8Eh5+cEm
 GSvlKHWWKuZSN6fcqTQD3GsO8QeD5qkCsZtk8tN6afni

On 11/21/22 07:34, Benjamin Coddington wrote:
> On 21 Nov 2022, at 8:56, David Howells wrote:
> 
>> Benjamin Coddington <bcodding@redhat.com> wrote:
>>
>>> Since moving to memalloc_nofs_save/restore, SUNRPC has stopped setting the
>>> GFP_NOIO flag on sk_allocation which the networking system uses to decide
>>> when it is safe to use current->task_frag.
>>
>> Um, what's task_frag?
> 
> Its a per-task page_frag used to coalesce small writes for networking -- see:
> 
> 5640f7685831 net: use a per task frag allocator
> 
> Ben
> 
> 

I am not seeing this in the mainline. Where can find this commit?

thanks,
-- Shuah

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
