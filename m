Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29F39C54EBC
	for <ocfs2-devel@archiver.kernel.org>; Wed, 11 Jan 2023 17:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lGr0UHXovN0qxxeafib9QVc0DXCDGOBQnwGkQ4EqnKo=;
 b=j+SB/FNFJGK/uOrD8E5pP0Exk4j9lvZOhnZ9Ba9oGxEnN5SLDTU3wmg/5Sz4MnTqu7AEJahkZo0x
   ORjuEnCRllCBmTOIlcCCeQupixa0Wllcv/QhaozO05O29InqLYVrudvkP8GlrZhVs83Q7zEsI0Id
   F0UNtybgv3mxA7fzYMXHGso9JceyBaHu6qpfDqsoIIxPeSrOs9tCXBCTPA6PsRUdJz3jHiuH7uHH
   Sajk03WjLacceFzkTA2gclS7kF4Oc432AGxEBaefAgdakMHbSVpWnMkAogNTbtt1GqSVNNdjr16B
   D8dDwutEUjvTepMCTTt8MdJLpH2gD1Jym5rDbg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lGr0UHXovN0qxxeafib9QVc0DXCDGOBQnwGkQ4EqnKo=;
 b=q8a7xMgRi7cca0QDhoaJPAyW2/hfqQT4R+zn9VLh4G/YORwZO/B5LaGVFeLLCqG31qKPv2D0LoAq
   3sntTMb1GOauz77X8R7sCIdVvxqFkqW5dWIHjCk/xqOlF93Z22gynazV9DGAZB//DQN7ncloX1Hd
   47BaEjwBtN0mc50mSJ9ijrW0+aJZ1GFxFeeHqpMa4DZ+TyWjJ3oE611EghlGPaCMrIMuDbA/7vou
   mIcfsAHmX/FXgjrN/d293VF9NuAjP2/de3SjpAB47yI5M0ciAQ2Wr7JqUG89B5ZyM8l5ZT3H7ZTm
   55ZJX+8CoVdUzeR2xJQPJwTc0vkj0ykUuSwU7w==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROC00BSK0BSUJD0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 11 Jan 2023 17:23:52 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1673412849;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=AwDGIIG2kEW7th9yR8DoIeZiikP/oVS4/IYm7KTM+N0=;
 b=brBsQQCOn3YNpLDRSqJ0fzxkPgWTd4vbAn6G6HjRvF4ftTEjYNlIg2wBSn3tcP5h2zfNIk
 jWqFpNqwVQdt3rHPjEQTY6pwwFqd6aMMsecCM9qO+H49BcBd/QzXarky/Q/461Wvi4a92Y
 V+yqgBm2DJ/BldL60Ie7/m7IEX5QWqQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=AwDGIIG2kEW7th9yR8DoIeZiikP/oVS4/IYm7KTM+N0=;
 b=ky8WEwS0enC30MgiNg2rl7AvHrxil07/kjuupAHTzWQey6R5ZlOZ/kfyexm2j55xnJ
 bIJ4ddgdnaZ4GGfFtxSyGodmVW62l88z/fjesd0UoTtX3dH6u2zM6mqTQWHpSfVlmrJu
 cmYcBI3b4yXQRJGvABR+vLrsj/Rm0jqxLy2EkB+xnaSmWdY7NzGyfU7dzGV0WPREGQ6m
 4PjjSSbnhpUmABCoaaNgvi1aUE1EyUCizLNjgvV1HxupLbj9K/6nUVBIUAeN4MdoZcss
 K6F8iMKX8u3sJkBV/PzEXE7NjSnSIL1SHWSUWPZRWcNu+klbsP9Or7FFeAC3U0azHpfT B4Fw==
X-Gm-Message-State: AFqh2kqBZ/eEhCDxJLWMebk3wx9kjweTyQrJErW58DUC7nRwC+ooX0sY
 H179O1SgjgVxd2MAqCh5VWIF32v1AufpPmT+Mrf3MeCL8wIdDGiCmpYFC1DCkWANhDmuWyjHgly
 xsZI9qp/cJQ/+bbjIYCoHJA==
X-Received: by 2002:a17:903:50e:b0:189:bda4:4a39 with SMTP id
 jn14-20020a170903050e00b00189bda44a39mr68317514plb.49.1673412846855; Tue,
 10 Jan 2023 20:54:06 -0800 (PST)
X-Received: by 2002:a17:903:50e:b0:189:bda4:4a39 with SMTP id
 jn14-20020a170903050e00b00189bda44a39mr68317481plb.49.1673412846568; Tue,
 10 Jan 2023 20:54:06 -0800 (PST)
Message-id: <330d1f1b-02b2-ceb1-5df5-ef6ce0061eb2@redhat.com>
Date: Wed, 11 Jan 2023 12:53:49 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
To: Jeff Layton <jlayton@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Eric Van Hensbergen <ericvh@gmail.com>, Latchesar Ionkov <lucho@ionkov.net>,
 Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Ilya Dryomov <idryomov@gmail.com>,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
 Ronnie Sahlberg <lsahlber@redhat.com>, Shyam Prasad N <sprasad@microsoft.com>,
 Tom Talpey <tom@talpey.com>, Christine Caulfield <ccaulfie@redhat.com>,
 David Teigland <teigland@redhat.com>, Chuck Lever <chuck.lever@oracle.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Bob Peterson <rpeterso@redhat.com>,
 Andreas Gruenbacher <agruenba@redhat.com>,
 Namjae Jeon <linkinjeon@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 Anna Schumaker <anna@kernel.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>,
 "Darrick J. Wong" <djwong@kernel.org>
References: <20230105211937.1572384-1-jlayton@kernel.org>
In-reply-to: <20230105211937.1572384-1-jlayton@kernel.org>
Content-language: en-US
X-Source-IP: 170.10.133.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10586
 signatures=596816
Cc: linux-cifs@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
 linux-xfs@vger.kernel.org, devel@lists.orangefs.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 linux-afs@lists.infradead.org, cluster-devel@redhat.com,
 ocfs2-devel@oss.oracle.com, Steve French <stfrench@microsoft.com>,
 linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
 ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: Re: [Ocfs2-devel] [PATCH v2] filelock: move file locking definitions
 to separate header file
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
From: Xiubo Li via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Xiubo Li <xiubli@redhat.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: fhCpxebROyK3KIYlObKQDw-1
X-Google-Smtp-Source:
 AMrXdXs+9rrIRD+6pRvHkwnX14gh2BCpLNg+4mxFg/ySKLAFpFMrHGq/R+Lf/NnqdSw7vAx/2ZYhMg==
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 ip4:136.147.176.0/20 ip4:148.105.8.0/21 ip4:149.72.0.0/16 ip4:159.183.0.0/16
 include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 ip4:136.147.176.0/20 ip4:148.105.8.0/21 ip4:149.72.0.0/16 ip4:159.183.0.0/16
 include:spf1.redhat.com -all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: qLQ_mo6u5z-ctJEQFuwMse0mMLWw-_x0
X-Proofpoint-ORIG-GUID: qLQ_mo6u5z-ctJEQFuwMse0mMLWw-_x0
X-Mailman-Approved-At: Wed, 11 Jan 2023 17:23:49 +0000
Reporting-Meta:
 AAHdoqbza7QrHicv1nb7fQjRlLczVJoTDXOHCsQVSTtfz9oyRX5XyVCiANW2rt8t
 pMgD/7iL4mtkzm9cxoVujWhlK7vFTwT/GbR2zk8rbAWjQAg1YBQQ6ZEADP5bICmG
 J1sn8fTYkYiILu8p1J4WdTbxs3XIQka+OI7vSWuHkKO+FKqY+WL6yEW8Fre2YomD
 kKqbwwqpwr4sqR/egyfU6EuZhgMUstolbRoJsVVNY47zYn6gFpn9Ea/aBeMv3ga2
 CIsrbhNh60HoL9v9ohQLAefB4EVZ9fKr5W5EzKSSzT+JNItKEMxtg67L6zFH8leO
 QDiUwyvRC3UDzPyeyIqEhPUgtXIOqeUaxu52L09palyQBTylM/ekBg+tt6ErQCdH
 WQwPwSXJsPqm+xOUDOtu81Pam9NtQIYUHKgGrYk4N9/1v549ezUl/R1PRCb3uUrQ
 em7hg4deSxVm2KdRAiGCYUpR8V0ylqRiPuuJjKl+4Hm7Wfg6ySNTeB6aa4vKjbTh
 NIDkUcH6G95kv5zkKFUDIN5Z2w5l1wicFMyE1ABh5gs=


On 06/01/2023 05:19, Jeff Layton wrote:
> The file locking definitions have lived in fs.h since the dawn of time,
> but they are only used by a small subset of the source files that
> include it.
>
> Move the file locking definitions to a new header file, and add the
> appropriate #include directives to the source files that need them. By
> doing this we trim down fs.h a bit and limit the amount of rebuilding
> that has to be done when we make changes to the file locking APIs.
>
> Reviewed-by: Xiubo Li <xiubli@redhat.com>
> Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: David Howells <dhowells@redhat.com>
> Acked-by: Chuck Lever <chuck.lever@oracle.com>
> Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Acked-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   arch/arm/kernel/sys_oabi-compat.c |   1 +
>   fs/9p/vfs_file.c                  |   1 +
>   fs/afs/internal.h                 |   1 +
>   fs/attr.c                         |   1 +
>   fs/ceph/locks.c                   |   1 +

ceph part looks good to me.

Thanks

- Xiubo



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
