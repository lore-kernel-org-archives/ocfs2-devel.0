Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD6DEC25B0E
	for <ocfs2-devel@archiver.kernel.org>; Tue, 16 Aug 2022 23:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=13KIAK4nuOIYNmTi/YnDLL/NDn/n1bDkvOnXgChOPOY=;
 b=sScEuQXsnEUtSGZVX8BIZXazUE98moYp73Cr5EYiML5BI15Luhtjinq2X2xhhKVwjkIp+Rv4HK2I
   KfEwmy/ncueJcI38mgqO03oT2KXwpmru452IvFjsOPS8M3mi2WFsiVQgXGoOLSzNmt2AvKHKSONM
   UWSYqpeWOv0O6lKA5fRRBq7HXHS8kdsYdZvcwTJpu6aA8S9UArPJtZcjwLs+na0cc7CkGOJjxXXE
   8xuHvqUlFWsS60+++ZxMAOk4MNTEyPtboAlQl3y/gK67h4K1JErS+IOW81PtMRd0269yOTAksdT5
   4i5KstJTrO10Pa1uQEt15o1wGoyS4yiR7jLIJg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=13KIAK4nuOIYNmTi/YnDLL/NDn/n1bDkvOnXgChOPOY=;
 b=BqDj/vnHA/uIxbF6XCbBHyzow4ZYTUNYm3Ba+f9OcGh2Mo8/yhTXX8eViVECSX+jg9rfeTBKQJyP
   4PSChBYrFn1mePZhg2PTnlrr35KOfHr1iIhESkfQVsnZSZOZdcHlsN7Gi45JRUsntBEX7qNfeciM
   TQCSd+qPGu2HjUUIGIF+Eily6qPWGLOoVmGk394r8IifTOhyaYzky7NRGw+mqzaN90xEAXEUAHWZ
   H1knLrGBoc9Lb7g0IEmIav6f7q95Cm+ncvIrIUnhcUPHyKa5SCusz8Dsjdy56pdlq+d3VIENU9ks
   br5UWbBCfQ6Gp6dTr6hYvb7Z1a4D3L8NEKnnzQ==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220805 64bit (built Aug  5
 2022))
 with ESMTPS id <0RGQ004H2DP08P80@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 16 Aug 2022 23:10:12 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux-foundation.org;
 s=google; h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc; bh=AMn3B3jYdCVxak8yksa8T7jS8rFLGuSxkkP5+8axw1A=;
 b=Vm9rZhcUXu8DUu2U13LfpsCp0dP7Fg/9rAJeZp9YtlQ9Rq7Y9VtHRIc4gUGBrf6ABe
 +ZW0OMEq5BRJFyJbSJSx/y9p2lZo+15ohYnjJN9vM+Oe2v51uKNkPu3wDgexSVnVScq8
 +r2XB8pHGFS6YRv4syJ3wdNKjMUHxv1d12zww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=AMn3B3jYdCVxak8yksa8T7jS8rFLGuSxkkP5+8axw1A=;
 b=EV+UtnzMiUoXiGVjLN0cd30Hr3v43KojuIUeDu54RhEow4HGnWKTqfL5DdxDETnbsI
 ynK8ZfHtWJsS63ZEo6LvmNkQiYd1g6STL873VKy3usjV0bTwJze/RERd4Y7/zHDF1DKY
 Zi5Q5uNngDd0Kk2EmF1qPfPHOMP9Npv5Ybz8ytJ7yseyxEeCljNvEEgN8V7ZTjbwvbmA
 bzC91C9prPL6zAvQlHaSf3cF4GgmC+fRWp51fztriAbkzipoMYEc/UPn2Qpq7jjRUBEw
 hTyZf9qPzp/+l9UbvrVy1IS08+M/8Uj8JW4MV8kOQniGiguez62lW2Lqk5RexEQx1bIN S4XA==
X-Gm-Message-State: ACgBeo1BRqkeC9zah5H4D+eO0nKeH7BVclX1Yz3lN961rcDJeg1Z6piq
 UrcpxiUgFj3NSREA6QV5JTTc7XKvya/Wy+qL5mQ=
X-Received: by 2002:a17:906:8455:b0:730:ce3b:5b13 with SMTP id
 e21-20020a170906845500b00730ce3b5b13mr14720004ejy.151.1660691399930; Tue,
 16 Aug 2022 16:09:59 -0700 (PDT)
X-Received: by 2002:a05:600c:2195:b0:3a6:b3c:c100 with SMTP id
 e21-20020a05600c219500b003a60b3cc100mr383338wme.8.1660691398572; Tue,
 16 Aug 2022 16:09:58 -0700 (PDT)
MIME-version: 1.0
References: <YvvBs+7YUcrzwV1a@ZenIV>
 <CAHk-=wgkNwDikLfEkqLxCWR=pLi1rbPZ5eyE8FbfmXP2=r3qcw@mail.gmail.com>
 <Yvvr447B+mqbZAoe@casper.infradead.org>
 <b05cf115-e329-3c4f-dee5-e0d4f61b4cd5@schaufler-ca.com>
In-reply-to: <b05cf115-e329-3c4f-dee5-e0d4f61b4cd5@schaufler-ca.com>
Date: Tue, 16 Aug 2022 16:09:42 -0700
Message-id: <CAHk-=wiRs8k0pKy36cXYnBFVCJDP5DQMf6JM7FnRJz5tF4cMBA@mail.gmail.com>
To: Casey Schaufler <casey@schaufler-ca.com>
X-Source-IP: 209.85.218.43
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10441
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxlogscore=863 spamscore=0 mlxscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 priorityscore=134 adultscore=0 bulkscore=0 malwarescore=0
 clxscore=198 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208160083
Cc: jfs-discussion@lists.sourceforge.net, Hans de Goede <hdegoede@redhat.com>,
 devel@lists.orangefs.org, apparmor@lists.ubuntu.com,
 linux-unionfs@vger.kernel.org, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu,
 linux-security-module@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
 Sungjong Seo <sj1557.seo@samsung.com>, Namjae Jeon <linkinjeon@kernel.org>,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] Switching to iterate_shared
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
From: Linus Torvalds via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Linus Torvalds <torvalds@linux-foundation.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AA6agR4gITsqDyn1ZQwzae2JjQJXVrmw3R6eFjtmbQaTtdtEkPGX0LVuccvaKcrCLNN8OkypibN7IQ==
X-Gmail-Original-Message-ID:
 <CAHk-=wiRs8k0pKy36cXYnBFVCJDP5DQMf6JM7FnRJz5tF4cMBA@mail.gmail.com>
X-ServerName: mail-ej1-f43.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: gqIBIAmTZDvBUANCu6zt_lM3dE7TxXiS
X-Proofpoint-GUID: gqIBIAmTZDvBUANCu6zt_lM3dE7TxXiS
Reporting-Meta:
 AAGJzL78IRIIKACTDd+v/iM/NMjG5/wYfd/C2/3pSE/gyNWWcuOy7dfqM9PThuG1
 r6bLpg6+CgmL4NYfa9gGfqXBgC9srbnx8gRHyXj5WyajDYVBs6TCizWFcwY5gsBC
 gscnk6dY99KAvWDBeQZchHrmO41i/8YvLiH//YqgguOBkF+Z0HxeKlxnlyO6UWXU
 +SqjKoO/dAZoaSoi+wzXE43LSQRPAJJHLvT37uRGpOAVHOr30TXuyWSn6Ogx7+5+
 E9YM5LgR/LBbBuOPwm0kzaLlwAsKp4W5Sz6DLCNNrlASQMK/kY+eN4FEu9S1zf1w
 FAdqQwrgVot1eLerNLFgxUiKHYO+rLQUcOADdx5OVkjaCAvHvWo9jHB8gl2lLfL8
 pnb/3h9e8/69QnOI6XcxR2IvPDKmZ8o+wXiSfPUc7QxrSOZSt3C++bmEjYMCYjFu
 Bshl+FvUjX+MFjE1XHmfwwQ/DvUTuG75BxXfC76EG8YTGVxga2jTCLe8OKRO3PSZ
 n2wjMcQH/YkcGAU7yr7q2M1DFR9ogyOJTSuXR9wtYVSu

On Tue, Aug 16, 2022 at 3:30 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> Smack passes all tests and seems perfectly content with the change.
> I can't say that the tests stress this interface.

All the security filesystems really seem to boil down to just calling
that 'proc_pident_readdir()' function with different sets of 'const
struct pid_entry' arrays.

And all that does is to make sure the pidents are filled in by that
proc_fill_cache(), which basically does a filename lookup.

And a filename lookup *already* has to be able to handle being called
in parallel, because that's how filename lookup works:

  [.. miss in dcache ..]
  lookup_slow ->
      inode_lock_shared(dir);
      __lookup_slow -> does the
      inode_unlock_shared(dir);

so as long as the proc_fill_cache() handles the d_in_lookup()
situation correctly (where we serialize on one single _name_ in the
directory), that should all be good.

And proc_fill_cache() does indeed seem to handle it right - and if it
didn't, it would be fundamentally racy with regular lookups - so I
think all those security layer proc_##LSM##_attr_dir_iterate cases can
be moved over to iterate_shared with no code change.

But again, maybe there's something really subtle I'm overlooking. Or
maybe not something subtle at all, and I'm just missing a big honking
issue.

            Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
