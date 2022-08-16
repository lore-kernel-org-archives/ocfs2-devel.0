Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E32C1C25B0E
	for <ocfs2-devel@archiver.kernel.org>; Tue, 16 Aug 2022 22:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ECNih75HCgPGnlgkZDr4BnK2kvmaufORtPbjnPv9IDk=;
 b=lH5N5ffCb3TInlHCWb2ak0L/LnaO1MrXOznul3EXX7/59cfd6+Rsoc5QUBlHd1B0M8OxNji9vGdz
   QURTEIs3e9GQgMbBXxY1uBZvbwOB6svrrPmPKIRZV+QI4s3I/urM7fkvDdqKeedHCY2IDEeea9wN
   L8a9hMuB1TclBRKkQBfwEKis2Guz9g7jeo8RScmFSfS4DIQTa0g0cE4+SjY+OgerOyFJvg4x9E06
   Q/2kbs7un/WLDn1gz2jH9uiL+9PUqhvjThBeslpMpUMFEJMtZ7+c3QjYjvInu3XPHvrrR8ee+HoW
   Ifm5skvq2YV8djLRh+hE9DjU2sMNCyRC5JPK/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ECNih75HCgPGnlgkZDr4BnK2kvmaufORtPbjnPv9IDk=;
 b=tY9ZRJrzcFktSu+oUJcTewvP5J0LvaOiz4/Lthv6i1lp6ADJcJGugi4VaMWZhny1EewoXvqTb/QV
   L5Cqe8C0PeNPbUAT1gaDFxqp/p84bVvYk2RsDGDvCccmkA162DRPLeciKaagcoHcKyuot09vWGRx
   zTpoUbawmCL0MEDQahr4OQggMPrgITTfo15Iqe7fVZ22qhpNGFCmksu2tadr1Taf2k6P5MlS/Try
   p5g2QnBDSzjfdzaD5IlgickZ9MdmZbi5yWRiegnX8vQ6cYiGW6bP4lIY1iAq8b+AChmb2ayN+zHR
   geBM9N6ZTzhy/0oPf+5MHAP3L3c/ub4HoeOyrw==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220805 64bit (built Aug  5
 2022))
 with ESMTPS id <0RGQ00A9TBUWG500@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 16 Aug 2022 22:30:32 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
 t=1660689019; bh=Uwi0AjOd+BUCbQ5EFKaVcYyqsN0PvU3/YuRCxGxtiv8=;
 h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To;
 b=ILwrXMz5bCmK6CQ6u9rt+cO05fRmf5ASvcWdRllgxJukLtkFOst+mPdHIdJWu/jCn+dFphBwSR1nILl7junfde3MeudLBEDixgvmDEnSWGd9jXgvqhWnEFsOjm5o343t8pBWNJNDJoW1DHpYQZzt9Uf1gnRXbKgc5vwCfE+hvwxeDU5QiTyfT9lyzqd3DwXV9yGxnsYWWiy+f7yt4m4jPMIFo2tqj/LrTcd1kcsgA60OI/POZ2SK9haNwigKe+yeBCLj3WzlAB/od9lHGJ9elDTUxMhv0Lfjm3TNheUQLhgpnZ7awRd+MZrmNfymlyU5PV0GG7XOhmSioIaB5EK+oQ==
Message-id: <b05cf115-e329-3c4f-dee5-e0d4f61b4cd5@schaufler-ca.com>
Date: Tue, 16 Aug 2022 15:30:12 -0700
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-language: en-US
To: Matthew Wilcox <willy@infradead.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <YvvBs+7YUcrzwV1a@ZenIV>
 <CAHk-=wgkNwDikLfEkqLxCWR=pLi1rbPZ5eyE8FbfmXP2=r3qcw@mail.gmail.com>
 <Yvvr447B+mqbZAoe@casper.infradead.org>
In-reply-to: <Yvvr447B+mqbZAoe@casper.infradead.org>
X-Mailer: WebService/1.1.20531
 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Source-IP: 66.163.184.153
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10441
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 impostorscore=0 suspectscore=0 priorityscore=30 spamscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=466 bulkscore=0 malwarescore=0 mlxscore=0
 clxscore=98 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208160081
Cc: jfs-discussion@lists.sourceforge.net, Hans de Goede <hdegoede@redhat.com>,
 casey@schaufler-ca.com, devel@lists.orangefs.org, apparmor@lists.ubuntu.com,
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
From: Casey Schaufler via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Casey Schaufler <casey@schaufler-ca.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
 t=1660689019; bh=F9Um+8Qj1zDoFjWk2W5q4vhOhwSxnZeEi72hH2YeqUd=;
 h=X-Sonic-MF:Date:Subject:To:From:From:Subject;
 b=eKzh3OoTdvvQ8h5C2uQdXvcYR3roq44BWp5kFl9lbvDBoEDO6+qt4KZ8tBtGRjAxPU1y3nH2R6+H1uYoTgvv/CXY1bpbGR0gQw1ydJYb9Ly+2bz+P2L2jr0Twg928uCJ2MA9d0mNO94NiCNRanQ1ZVW0pGCdiCscgbriNo/16zDtpamUUP/9Q7fgH9wqMPKtYFf5WsOP7E/iV+/8hTNzusOayQKDoDi9iKQruqS0z6z6QcL8LbAnmA1zy9lNDvqlZn+146jVN3FmVP1IhPyiNOyPsg0RW660L/y6n1LsoUGm1CSAY3lQZy7fgkYjKv1u2R2vauyKSdncF4DG+mkROA==
X-YMail-OSG: 23.PvCwVM1k1.Y5WVt9ruQrpMW6tE8J5qcxcl8osV_JGIYlbxBEuWWQ7kyr7kc8
 xGpGF5wIpIwnETVA1Kx5VXzc49m1wqOyHwb1Myxdt3Z9Lf_GyWDaJrS9p4KfPTeKV3cU.ejmyF4y
 eP_81AEbFciQ.KWsDOWOmKQQNiupft596D0ywMiUtGQ9cVB55aZ5cteG_7yxsaHrCeVPTtKRhtAG
 rgPV8NQUxtx6jbBXQ_LocYE4m.2gz0I3MWO14QnOLJ7A1umRhEfo2hxGQeY67z0eAVsH7_se7oda
 1RzzNDTPRrc5oSXbNtwLgWa.T9GssCfgfwLQwf_J60_iBV.Vv7A8PO3ZwMwJvQltuRBJ7m6B.v7u
 CFKVXtPU43SCnZXI2_fjWJhilYUvXtPupx6LoANrrVf6CJtyO2E58jljFrL3yuLIcbt3EQLJcHoh
 2nPpgoFl34nqYGpER8vRyFoqfpuk0BBHNi9GbpNb0emxf2pD0Qdwn03JEmGIFozi6eqyM8sFf5LL
 sDfMDbjn9GU4CxaZlU9ppG1M30RQK147VKh9a5BbbBuwHmOgpTi_HYyl9bYaMVFgSExBobmOzmno
 zikeFPDwpcyTgt4t_R4APcpq0HD3I4HoBJETfW1XpXmBDDKeGPiEKqKC_c1Vl7KeqkdOg1RCacxZ
 pdELmj74_Q8fpFr_Y_wSiAVXXAhnjxIXPUIhZhP1haLJksDhPhvEx1rxpXeh4VNzVXt0bsQo7gmt
 cV8hlSozTBbWvCAl6304JTyphIhsLL0iayuOKamYKGxFM8P8cwcp3JJCqJFsHJmOYtD7rt6uUOra
 bl2.xcvSi51XdwvlA63RnchfHVIO.8MvK7_1YYvS6dmRB4MOSNEL9Aw9wIzt9idhSAugoKWMFDcV
 I0mNsLEYhFMREOfDWZ5duWrTqdB7K_vuf.M4eWeCASIdf7xUxhGbzUXPecVOFrs6sLpfrnpcZ4Nu
 2Dhwg5lHdVdEpydcWty5JWks3jdmpffkhpnZ57e_2aAWI29ym3WnahPO7jtza_dpBqpXDlfLRAp_
 qdvAzf0Xyr4sbhXNK0Dn0INsLEFc9d.v7VOOLXg76E4B6FKRvhfxfUE9HaQpNXVyHg7DQj188rL4
 3.jNDw4gqqWnOlfNkciVS73iwXLDIrJYRdiTPaSCnTHMH3LmclRuz2t6h_JOJ2vOg8eNNn5mtAss
 5EowhVxXaHCzjlkDny4xF5pn3cx45bUxlQgB6hHXa0bc_SzlnDgI2bCXDzdMG9iLI54JRxSYNxTI
 czQpdDPkhXSOLSzsu9z9AYRZixuFmdChTrXE1incTmB9ch9YYbJwxkQkZ1C.fLifdQ6ENZP2pO1F
 IfndtLGo919uTdh1GNLE9HOZFF6FRnHOYabTwLy4XsPXf2Nb0r4969fJzVqWwKRZMOKxXTE8PDd2
 GGpcjeDfcHPhFlN_50EsnRKksW4.GwK8OPaRwppqhFLNL_zSBOVGgGlTpbCbN71aGqELA62kTAZV
 OYsBOhFLYP4om5dteCrS7XX3MsfMV05L5ZmbiKPb0vHkyJt3ROt8gnoc.buBIVEtpFpVKdK0EMq3
 gLEyLMcdKpY8f5sJy2lYuKfsUkdg656_MyKe2IsSdq1ni6pINFcj1rsE1YRf1qPNrPRl4BUeunHM
 oFvKz7CEUlNfRmYAI01lpfv3vuj0xwhBvPZnTBl5Xr4SMsPkd3_esqkVo5o5qXZ.O.P_03mWD.Aa
 NWC3JIoF8NOCvUMmz9Vvc7E1SjxuV6hUHeSluyYrkq6ASDX0g.HVcwzHyA8WBmSA42QbflrsMuy2
 2QtOz4DTAIaK3oPda6TSf_WS5ki8EPxGQKniVz1KiNCneEVvfqGJ.6CEvffsS8jZDxYTj8DJcESn
 DJ5XIhgMwq7k3U90w.CQbDbC5iBDyrxBIXIQ2gPd3xGWuucmLlhedZFiDeALSQtwuzpE2m1SmEVp
 b0.9jQRJlFAocjLtojKh9k8cp.r0VileD5MZzqi6DNd8pKPyTrRfGRWSImAPiObXRN5dVM8bCYLa
 RuKwrHxalDYRGzUsrvGu7MNQXHxCbnVHPiduJaxkNf1MDq1fhyFxH.49jOfOiwyw5x465SkJVJMw
 j9iOc2MrT0A0hVZYQDx8nZ0LGDroWVYnl9XXU1Nm2IxE3qvlMrZqAHlvb2RFJ9uiA5gBW6wZ8B14
 l_4j7jzGrTad5QUJsvsFlkVL8JnlhVay8fOtD74tY6ty_gFxjETKWGorzcuU5CFMg_KRvAppb6Df
 UX2wgL75UdBL3ByEJGvPLeiNS6VBNgO.4dDWcpiiRvlPj.5bYrQY8nB7U5pI8lg--
X-Sonic-MF: <casey@schaufler-ca.com>
X-ServerName: sonic309-27.consmr.mail.ne1.yahoo.com
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: Dnaeu1Od-3-wEm7Pag7ka4Am-P8XtF0T
X-Proofpoint-GUID: Dnaeu1Od-3-wEm7Pag7ka4Am-P8XtF0T
Reporting-Meta:
 AAEF4Qn8GQ261K48AMKzK6lPMGii47U86zXTrN3Ye5crYQ0NTiGgyVDvH0fR84vm
 BiNtGy7ZwgIq99NJDVIl3aTeCQ+EBs7H3HMcjxY6WP6kkno32bo0C3PanW/UaRjR
 gWO7rUgoBlb1IrSo8IvCF/Hvibmx/1EYsNHF0xbg7Y843FiY9q48OIdOmd195E5H
 3aSkZb3TYnqu+z4TrzreE2HlJkoVeW6zH6WEgMpbUP716DZOMMlrIkV8kXi30/Zw
 dNUadS2MxY6KLfd7cJCEVrdfN2h+anr3zxoMa5IF/bKMxF+H5yT9qCXRlx6qptsL
 j3wKV6H4Grlaw2GQUP12NJZxZYjywPnr41gn1Rd9/SKxLBI0HmaIBZFxNObQRdMe
 KXuhDJ7S5+AQM1zjaTkFHLtgY8uDqsHtrA/0vTYy1pXXfBQ0CLnREG/vVZWaHBPK
 3NjNdc/6m+RCkx2DUUtC/zkO1PzqS0Fu3kI1uafDQ657d3/uXL/PLiV6TC2IzolV
 p8wNKhFZ7lmT5ZwDAWyt8x2K2PU0AZRIOZjKFq7+fsUv

On 8/16/2022 12:11 PM, Matthew Wilcox wrote:
> On Tue, Aug 16, 2022 at 11:58:36AM -0700, Linus Torvalds wrote:
>> That said, our filldir code is still confusing as hell. And I would
>> really like to see that "shared vs non-shared" iterator thing go away,
>> with everybody using the shared one - and filesystems that can't deal
>> with it using their own lock.
>>
>> But that's a completely independent wart in our complicated filldir saga.
>>
>> But if somebody were to look at that iterate-vs-iterate_shared, that
>> would be lovely. A quick grep shows that we don't have *that* many of
>> the non-shared cases left:
>>
>>       git grep '\.iterate\>.*='
>>
>> seems to imply that converting them to a "use my own load" wouldn't be
>> _too_ bad.
>>
>> And some of them might actually be perfectly ok with the shared
>> semantics (ie inode->i_rwsem held just for reading) and they just were
>> never converted originally.
> What's depressing is that some of these are newly added.  It'd be
> great if we could attach something _like_ __deprecated to things
> that checkpatch could pick up on.
>
> fs/adfs/dir_f.c:        .iterate        = adfs_f_iterate,
> fs/adfs/dir_fplus.c:    .iterate        = adfs_fplus_iterate,
>
> ADFS is read-only, so must be safe?
>
> fs/ceph/dir.c:  .iterate = ceph_readdir,
> fs/ceph/dir.c:  .iterate = ceph_readdir,
>
> At least CEPH has active maintainers, cc'd
>
> fs/coda/dir.c:  .iterate        = coda_readdir,
>
> Would anyone notice if we broke CODA?  Maintainers cc'd anyway.
>
> fs/exfat/dir.c: .iterate        = exfat_iterate,
>
> Exfat is a new addition, but has active maintainers.
>
> fs/jfs/namei.c: .iterate        = jfs_readdir,
>
> Maintainer cc'd
>
> fs/ntfs/dir.c:  .iterate        = ntfs_readdir,         /* Read directory contents. */
>
> Maybe we can get rid of ntfs soon.
>
> fs/ocfs2/file.c:        .iterate        = ocfs2_readdir,
> fs/ocfs2/file.c:        .iterate        = ocfs2_readdir,
>
> maintainers cc'd
>
> fs/orangefs/dir.c:      .iterate = orangefs_dir_iterate,
>
> New; maintainer cc'd
>
> fs/overlayfs/readdir.c: .iterate        = ovl_iterate,
>
> Active maintainer, cc'd
>
> fs/proc/base.c: .iterate        = proc_##LSM##_attr_dir_iterate, \
>
> Hmm.  We need both SMACK and Apparmor to agree to this ... cc's added.

Smack passes all tests and seems perfectly content with the change.
I can't say that the tests stress this interface.

>
> fs/vboxsf/dir.c:        .iterate = vboxsf_dir_iterate,
>
> Also newly added.  Maintainer cc'd.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
