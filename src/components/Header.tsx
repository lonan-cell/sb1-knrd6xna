import { useState } from 'react';
import { Link } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { Disclosure } from '@headlessui/react';
import { Bars3Icon, XMarkIcon } from '@heroicons/react/24/outline';

const navigation = [
  { name: 'Accueil', href: '/' },
  { name: 'À propos', href: '/about' },
  { name: 'Cultivateurs', href: '/farmers' },
  { name: 'Acheteurs', href: '/buyers' },
  { name: 'Contact', href: '/contact' },
];

export default function Header() {
  const { user, signOut } = useAuth();

  return (
    <Disclosure as="nav" className="bg-green-800">
      {({ open }) => (
        <>
          <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
            <div className="flex h-16 justify-between">
              <div className="flex">
                <div className="flex flex-shrink-0 items-center">
                  <img
                    className="h-8 w-auto"
                    src="/logo.svg"
                    alt="AgriConnect"
                  />
                </div>
                <div className="hidden sm:ml-6 sm:flex sm:space-x-8">
                  {navigation.map((item) => (
                    <Link
                      key={item.name}
                      to={item.href}
                      className="inline-flex items-center px-1 pt-1 text-sm font-medium text-white hover:text-green-200"
                    >
                      {item.name}
                    </Link>
                  ))}
                </div>
              </div>
              <div className="hidden sm:ml-6 sm:flex sm:items-center">
                {user ? (
                  <div className="flex items-center space-x-4">
                    <Link
                      to="/dashboard"
                      className="text-white hover:text-green-200"
                    >
                      Tableau de bord
                    </Link>
                    <button
                      onClick={signOut}
                      className="rounded-md bg-green-600 px-3 py-2 text-sm font-semibold text-white hover:bg-green-500"
                    >
                      Déconnexion
                    </button>
                  </div>
                ) : (
                  <Link
                    to="/auth"
                    className="rounded-md bg-green-600 px-3 py-2 text-sm font-semibold text-white hover:bg-green-500"
                  >
                    Connexion
                  </Link>
                )}
              </div>
              <div className="-mr-2 flex items-center sm:hidden">
                <Disclosure.Button className="inline-flex items-center justify-center rounded-md p-2 text-white hover:bg-green-700 hover:text-white">
                  <span className="sr-only">Open main menu</span>
                  {open ? (
                    <XMarkIcon className="block h-6 w-6" aria-hidden="true" />
                  ) : (
                    <Bars3Icon className="block h-6 w-6" aria-hidden="true" />
                  )}
                </Disclosure.Button>
              </div>
            </div>
          </div>

          <Disclosure.Panel className="sm:hidden">
            <div className="space-y-1 pb-3 pt-2">
              {navigation.map((item) => (
                <Link
                  key={item.name}
                  to={item.href}
                  className="block border-l-4 border-transparent py-2 pl-3 pr-4 text-base font-medium text-white hover:border-green-500 hover:bg-green-700"
                >
                  {item.name}
                </Link>
              ))}
            </div>
          </Disclosure.Panel>
        </>
      )}
    </Disclosure>
  );
}